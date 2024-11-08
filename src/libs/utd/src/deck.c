/* ----------------------------------------------------------------- 
 * Code donated by TimberWolf Systems, Inc.
 * Original Copyright (c) 1993-2018 TimberWolf Systems, Inc. 
 * All rights reserved.
 * Modified at University of Texas at Dallas (UTD) by 
 * William Swartz for public use.
 * Copyright (c) 2019 William Swartz.  UTD.  All rights reserved.
   Copyright (c) 1993 TWS.  All rights reserved.
   FILE:	    deck.c                                       
   DESCRIPTION:This file contains the routines to handle decks
   CONTENTS:
   UTDDECK *utDdeck_init( ) 
   utDdeck_push( deck, node ) 
   UTDDECK *deck ;
   char *node ;
   utDdeck_enqueue( deck, node ) 
   UTDDECK *deck ;
   char *node ;
   char *utDdeck_pop( deck )
   char *utDdeck_dequeue( deck )
   UTDDECKPTR utDdeck_notEmpty( deck ) 
   UTDDECK *deck ;
   utDdeck_free ( deck , userfree )
   UTDDECK *deck;
   userfree is memory deallocation routine
   utDdeck_empty ( deck , userfree )
   UTDDECK *deck;
   userfree is memory deallocation routine                
   utDdeck_dump( deck ) 
   UTDDECK *deck ;
   DATE:	    Mar 16, 1990 
		    Fri Feb 22 23:34:38 EST 1991 - fixed utDdeck_pop 
			utDdeck_dequeue when queue is empty.
   ----------------------------------------------------------------- */
#include <utdconfig.h>
#include <utd/deck.h>
#include <utd/mempools.h>

static UTDCARD deckEndS ;

/*-----------------*/
/* initialize deck */
/*-----------------*/
UTDDECK *utDdeck_init(void)
{   
  UTDDECKPTR deckPtr ;
  
  deckPtr = UTDMALLOC( 1, UTDDECK ) ;
  deckPtr->top = &deckEndS ;              /* init to point to sentinal */
  deckPtr->bottom = &deckEndS ;           /* init to point to sentinal */
  deckPtr->current = &deckEndS ;          /* init to point to sentinal */
  deckPtr->size = 0 ;
  deckPtr->free_in_progress = FALSE ;
  deckPtr->mpool = UTDPOOL_INIT( 0, UTDCARD ) ;
  return(deckPtr) ;  
} /* end utDdeck_init */


/*-------------------------------------*/
/* add a vertex to the top of the deck */
/*-------------------------------------*/
void utDdeck_push(UTDDECK *deckPtr, VOIDPTR data)
{
  UTDCARDPTR cardPtr ;
  
  cardPtr = UTDPOOL_MALLOC( deckPtr->mpool, UTDCARD ) ;  /* allocate a new card */
  cardPtr->data = data ;                   /* attach users data to new card */
  
  if (deckPtr->size) {       /* deck is not empty */
    cardPtr->down = deckPtr->top ;
    cardPtr->up = &deckEndS ;
    deckPtr->top->up = cardPtr ;
    deckPtr->top = cardPtr ;
  } else {                   /* deck was empty */
    deckPtr->top = cardPtr ;    /* the new card is the top and bottom */  
    deckPtr->bottom = cardPtr ;
    cardPtr->up = &deckEndS ;
    cardPtr->down = &deckEndS ;
  }
  
  deckPtr->size++ ;
} /* end utDdeck_push */

/*----------------------------------------*/
/* add a vertex to the bottom of the deck */
/*----------------------------------------*/
void utDdeck_enqueue(UTDDECK *deckPtr, VOIDPTR data)
{
  UTDCARDPTR cardPtr ;
  
  cardPtr= UTDPOOL_MALLOC( deckPtr->mpool, UTDCARD ) ; /* allocate a new card */
  cardPtr->data = data ;                   /* attach users data to new card */
  
  if ( deckPtr->size ) {       /* deck is not empty */
    cardPtr->up = deckPtr->bottom ;
    cardPtr->down = &deckEndS ;
    deckPtr->bottom->down = cardPtr ;
    deckPtr->bottom = cardPtr ;
  } else {                   /* deck was empty */
    deckPtr->top = cardPtr ;    /* the new card is the top and bottom */  
    deckPtr->bottom = cardPtr ;
    cardPtr->up = &deckEndS ;
    cardPtr->down = &deckEndS ;
  }
  
  deckPtr->size++ ;
} /* end Yadd2Deck */

/*------------------------------*/
/* remove card from top of deck */
/*------------------------------*/
VOIDPTR utDdeck_pop(UTDDECK *deckPtr)
{
  UTDCARDPTR cardPtr ;
  VOIDPTR data ;

  if( deckPtr->size <= 0 ){
      return( NULL ) ;
  }
  
  cardPtr = deckPtr->top ;
  data = cardPtr->data ;
  
  deckPtr->top = cardPtr->down ;
  cardPtr->down->up = &deckEndS ;
  
  if ( (deckPtr->current = deckPtr->top) == &deckEndS) {
   deckPtr->bottom = &deckEndS ;
  }

  UTDPOOL_FREE_ITEM( deckPtr->mpool, cardPtr) ;
  deckPtr->size-- ;
  return(data) ;
}  /* end utDdeck_pop */

/*---------------------------------*/
/* remove card from bottom of deck */
/*---------------------------------*/
VOIDPTR utDdeck_dequeue(UTDDECK *deckPtr)
{
  UTDCARDPTR cardPtr ;
  VOIDPTR data;
  
  if( deckPtr->size <= 0 ){
      return( NULL ) ;
  }
  
  cardPtr = deckPtr->bottom ;
  data = cardPtr->data ;
  
  deckPtr->bottom = cardPtr->up ;
  cardPtr->up->down = &deckEndS ;
  
  if ( (deckPtr->current = deckPtr->bottom) == &deckEndS) {
   deckPtr->top = &deckEndS ;
  }

  UTDPOOL_FREE_ITEM( deckPtr->mpool, cardPtr) ;
  deckPtr->size-- ;
  return(data) ;
}  /* end utDdeck_dequeue */


/*---------------------------------*/
/* Reverse the stack of cards.     */
/*---------------------------------*/
void utDdeck_reverse(UTDDECK *deckPtr)
{
  UTDCARDPTR card_p ;		/* traverse deck */
  UTDCARDPTR reverse_p ;	/* card to be reversed */

  for ( card_p = deckPtr->top ; card_p != &deckEndS ; ){
    /* save state and update direction */
    reverse_p = card_p ;
    card_p = card_p->down ;
    /* now safe to swap reverse */
    SWAP( reverse_p->up, reverse_p->down, struct utddeck_info * ) ;
  }
  /* now swap entire deck */
  SWAP( deckPtr->top, deckPtr->bottom, UTDCARDPTR ) ;

}  /* end utDdeck_dequeue */


/*--------------------------*/
/* check status of the deck */
/*--------------------------*/
INT utDdeck_notEmpty(UTDDECK *deckPtr)
{  
  return( deckPtr->size ) ;
}

/*--------------------------------*/
/* remove all cards from the deck */
/*--------------------------------*/
void utDdeck_empty(UTDDECK *deckPtr, void (*userDelete)( void *) )
{
  INT mpool ;			/* memory pool */
  VOIDPTR deckData;

  mpool = deckPtr->mpool ;
  if( mpool > 0 ){
    if( userDelete ){   
      for (utDdeck_top(deckPtr);utDdeck_notEnd(deckPtr); utDdeck_down(deckPtr) ) {
	deckData = utDdeck_getData(deckPtr,VOIDPTR) ;
	userDelete(deckData) ;
      }
    }
    if(!(deckPtr->free_in_progress)){
      deckPtr->top = &deckEndS ;              /* init to point to sentinal */
      deckPtr->bottom = &deckEndS ;           /* init to point to sentinal */
      deckPtr->current = &deckEndS ;          /* init to point to sentinal */
      deckPtr->size = 0 ;
      UTDPOOL_FREE_POOL( deckPtr->mpool ) ;
      deckPtr->mpool = UTDPOOL_INIT( 0, UTDCARD ) ;
    }
  } else {
    if (userDelete) {   
      for (utDdeck_top(deckPtr);utDdeck_notEnd(deckPtr);) {
	deckData = utDdeck_pop(deckPtr) ;
	userDelete(deckData) ;
      }
    } else {
      for (utDdeck_top(deckPtr);utDdeck_notEnd(deckPtr);) {
	utDdeck_pop(deckPtr) ;
      }
    }
  }
} /* end deck_empty() */

/*-----------------------------------------*/
/* free the deck and all cards it contains */
/*-----------------------------------------*/
void utDdeck_free(UTDDECK *deckPtr, void (*userDelete) ( void *))
{
  deckPtr->free_in_progress = TRUE ;
  utDdeck_empty(deckPtr,userDelete);
  UTDPOOL_FREE_POOL( deckPtr->mpool ) ;
  UTDFREE(deckPtr);
}

/*-------------------------------------------------*/
/* debug function to dump the contents of the deck */
/*-------------------------------------------------*/
void utDdeck_dump(UTDDECK *deckPtr, void (*userPrint) ( void *))
{
  
  fprintf( stderr,"%d cards\n",deckPtr->size);
  fprintf( stderr,"Deck top to bottom:" ) ;
  for ( utDdeck_top(deckPtr); utDdeck_notEnd(deckPtr); utDdeck_down(deckPtr) ) {
    if (userPrint) {
      (*userPrint)(utDdeck_getData(deckPtr,VOIDPTR));
    } else {
      fprintf( stderr,"%ld ", utDdeck_getData(deckPtr,LONG) ) ;
    }
  }
  fprintf( stderr,"\n" ) ;  
  fprintf( stderr,"Deck bottom to top:" ) ;
  for ( utDdeck_bottom(deckPtr); utDdeck_notEnd(deckPtr); utDdeck_up(deckPtr)) {
    if (userPrint) {
      (*userPrint)(utDdeck_getData(deckPtr,VOIDPTR));
    } else {
      fprintf( stderr,"%ld ", utDdeck_getData(deckPtr,LONG) ) ;
    }
  }
  fprintf( stderr,"\n" ) ;  
  
} /* end utDdeck_dump */

/*-----------------------------------------------------------------------------*/
/* returns address of sentinel. This makes sentinal address available to users */
/*-----------------------------------------------------------------------------*/
UTDCARD *utDdeck_sentinel(void)
{
  return(&deckEndS);
}

#ifdef TEST

#include <stdlib.h>
/* ##################################################################
                       TEST OF DECK ROUTINES 
   ################################################################## */
int main(void)
{
    INT i ;
    LONG top ;
    LONG data ;
    LONG bottom ;
    BOOL state ;
    UTDCARDPTR top_p ;
    UTDCARDPTR bottom_p ;
    UTDCARDPTR child_p ;
    UTDCARDPTR parent_p ;
    UTDDECKPTR deck_p ;

    utDmempool_enable(TRUE) ;
    /* Ydebug_init( TRUE); */

    fprintf( stderr, "Initial memory:%ld\n", utDmalloc_use() ) ;
    deck_p = utDdeck_init() ;
    state = utDdeck_end(deck_p) ;
    state = utDdeck_notEnd(deck_p) ;
    top = utDdeck_peek( deck_p, LONG ) ;


    for( i = 1 ; i <= 10 ; i++ ){
      utDdeck_enqueue( deck_p, VOIDPTR_TYPE(i) ) ;
      top = utDdeck_peek( deck_p, LONG ) ;
      bottom = utDdeck_peekBottom( deck_p, LONG ) ;
      top_p = utDdeck_top( deck_p ) ;
      bottom_p = utDdeck_bottom( deck_p ) ;
      parent_p = utDdeck_parent( bottom_p ) ;
      if( parent_p ){
	fprintf( stderr, "ERROR: we shouldn't get a parent.\n" ) ;
      }
      parent_p = utDdeck_parent( top_p ) ;
      if( parent_p ){
	data = utDdeck_getCardData( parent_p, LONG ) ;
	if( data != 2 ){
	  fprintf( stderr, "trouble getting parent.\n" ) ;
	}
      }
      child_p = utDdeck_child( bottom_p ) ;
      if( child_p ){
	data = utDdeck_getCardData( child_p, LONG ) ;
	if( data != i - 1 ){
	  fprintf( stderr, "trouble getting child.\n" ) ;
	}
      }
    }

    fprintf( stderr, "initial deck:\n" ) ;
    for(utDdeck_top(deck_p); utDdeck_notEnd(deck_p) ; utDdeck_down(deck_p) ) {
	i = utDdeck_getData( deck_p, LONG ) ;
	fprintf( stderr, "item:%d\n", i ) ;
    }

    fprintf( stderr, "\nDump of deck:\n" ) ;
    utDdeck_dump( deck_p, NULL ) ;

    fprintf( stderr, "\nReverse the deck:\n" ) ;
    utDdeck_reverse(deck_p) ;
    utDdeck_dump( deck_p, NULL ) ;

    utDdeck_free( deck_p, NULL ) ;

    fprintf( stderr, "Final memory:%ld\n", utDmalloc_use() ) ;
    UTDPOOL_FREE_ALL() ;
    fprintf( stderr, "Final memory:%ld\n", utDmalloc_use() ) ;

    exit(0) ;
}

#endif /* TEST */
