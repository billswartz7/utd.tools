/* ----------------------------------------------------------------- 
 * Code donated by TimberWolf Systems, Inc.
 * All rights reserved.
 * Modified at University of Texas at Dallas (UTD) by 
 * William Swartz for public use.
 * Copyright (c) 1992 Richard Weier.
 * Copyright (c) 1993-2018 TimberWolf Systems, Inc. 
 * Copyright (c) 2019 William Swartz.  UTD.  All rights reserved.
FILE:	    dset.h
DESCRIPTION:Insert file for deck library routines.  Add & subtract 
members from a top/bottom of doubly-linked list. Multiple decks may 
occur simultaneously.  The complexity of the routines are as follows.
    utDdeck_top         : O(1) 
    utDdeck_bottom      : O(1)
    utDdeck_up          : O(1)
    utDdeck_down        : O(1)
    utDdeck_pop         : O(1)
    utDdeck_push        : O(1)
    utDdeck_enqueue     : O(1)
    utDdeck_dequeue     : O(1)
    utDdeck_getTop      : O(1)
    utDdeck_getBottom   : O(1)
    utDdeck_getData     : O(1)
    utDdeck_size        : O(1)
    utDdeck_init        : O(1)
    utDdeck_empty       : O(n)
    utDdeck_free        : O(n)
REVISIONS: 
 * $Log$
----------------------------------------------------------------- */
#ifndef INCLUDED_UTD_DECK_H
#define INCLUDED_UTD_DECK_H

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

#include <utd/base.h>
#include <utd/msg.h>

/* *********** data structures *************** */
typedef struct utddeck_info {
    VOIDPTR  data;
    struct utddeck_info *up ;
    struct utddeck_info *down ;
} UTDCARD, *UTDCARDPTR  ;

typedef struct utddeck_rec {
    INT         size ;            /* size of list */
    INT         mpool ;		  /* memory pool */
    BOOL        free_in_progress ;/* free in progress */
    UTDCARDPTR  top ;
    UTDCARDPTR  bottom ;
    UTDCARDPTR  current ;
} UTDDECK, *UTDDECKPTR ;

/* *********** list macros ***************** */

#define utDdeck_up( deck_xyz )    (deck_xyz->current = deck_xyz->current->up)
/* 
Arguments:
    UTDDECK *deck_xyz ;
Function:
    Returns element above the current element in the deck.
*/

#define utDdeck_down( deck_xyz )    (deck_xyz->current = deck_xyz->current->down)
/* 
Arguments:
    UTDDECK *deck_xyz ;
Function:
    Returns the element below the current element in the deck.
*/

#define utDdeck_top( deck_xyz )    (deck_xyz->current = deck_xyz->top)
/* 
Arguments:
    utDDECK *deck_xyz ;
Function:
    Returns the top of the deck and resets position to head.
*/

#define utDdeck_bottom( deck_xyz )    ( deck_xyz->current = deck_xyz->bottom )
/* 
Arguments:
    UTDDECK *deck_xyz ;
Function:
    Returns the bottom of the deck and resets position to bottom.
*/

#define utDdeck_set( deck_xyz, card_xyz ) ( deck_xyz->current = card_xyz )
/* 
Arguments:
    UTDDECK *deck_xyz ;
    UTDCARD *card_xyz ;
Function:
    Sets a deck  to a specific card.
*/

#define utDdeck_get( deck_xyz ) ( deck_xyz->current )
/* 
Arguments:
    UTDDECK *deck_xyz ;
    UTDCARD *card_xyz ;
Function:
    Returns the current card.
*/

#define utDdeck_size( deck_xyz )    (deck_xyz->size)
/* 
Arguments:
    UTDDECK *deck_xyz ;
Function:
    Returns the number of elements in the deck
*/

#define utDdeck_getData( deck_xyz, t_xz )    ((t_xz) deck_xyz->current->data)
/* 
Arguments:
    UTDDECK *deck_xyz ;
    t_xz TYPE OF DATA or the proper cast to data.
Function:
    Returns a pointer to data stored on current card 
*/

#define utDdeck_notEnd( deck_xyz )    (deck_xyz->current != utDdeck_sentinel())
/*
Arguments:
    UTDDECK *deck_xyz ;
Function:
    returns false if current card is the end of the deck.  This is
    useful if the user wishes to make his own loop.
    eg)  for(utDdeck_top(d); utDdeck_notEnd(d) ; utDdeck_down(d) ) {
             operations on utDdeck_getData(d);
	 }
*/

#define utDdeck_end( deck_xyz )    (deck_xyz->current == utDdeck_sentinel())
/*
Arguments:
    UTDDECK *deck_xyz ;
Function:
    returns true if current card is the end of the deck. 
*/

#define utDdeck_getTop( deck_xyz, t_xz )    	((t_xz) deck_xyz->top->data)
#define utDdeck_peek				utDdeck_getTop
/* 
Arguments:
    UTDDECK *deck_xyz ;
    t_xz TYPE OF DATA or the proper cast to data.
Function:
    Returns a pointer to data stored on the top card 
    Note: this does not work with an integer set include zero because 0
    would be indistiguishable.   Use utDdeck_bottom and check for the
    presence of the sentinel.  This convenience function is available
    because most of the time, we aren't using that type of data.
*/


#define utDdeck_getBottom( deck_xyz, t_xz )    ((t_xz) deck_xyz->bottom->data)
#define utDdeck_peekBottom			utDdeck_getBottom
/* 
Arguments:
    UTDDECK *deck_xyz ;
    t_xz TYPE OF DATA or the proper cast to data.
Function:
    Returns a pointer to data stored on the bottom card 
*/

#define utDdeck_getCardData( card_xyz, t_xz )    ( (card_xyz && card_xyz->data) ? ((t_xz) (card_xyz)->data) : (t_xz) NULL )
/* 
Arguments:
    UTDDECK *deck_xyz ;
    t_xz TYPE OF DATA or the proper cast to data.
Function:
    Returns a pointer to data stored on the given card 
*/

#define utDdeck_parent( card_xyz )    ( (card_xyz && card_xyz->down != utDdeck_sentinel() ) ? card_xyz->down : NULL )
/* 
Arguments:
    UTDCARDPTR card_xyz
Function:
    Returns the parent of the current card or NULL if not valid.
*/

#define utDdeck_child( card_xyz )    ( (card_xyz && card_xyz->up != utDdeck_sentinel() ) ? card_xyz->up : NULL )
/* 
Arguments:
    UTDCARDPTR card_xyz
Function:
    Returns the child of the current card or NULL if not valid.
*/

/* *********** deck routines *************** */
extern UTDDECK *utDdeck_init( void ) ;
/* 
Arguments:
    none.
Function:
    Initialize deck structure and return pointer to deck memory.
*/

extern void utDdeck_push( UTDDECK *deck, VOIDPTR data ) ;
/* 
Arguments:
    UTDDECK *deck ;
    VOIDPTR data ;
Function:
    Add a new element to top of the deck.  User is required to maintain
    memory of the data element.
*/

extern void utDdeck_enqueue( UTDDECK *deck, VOIDPTR data ) ;
/* 
Arguments:
    UTDDECK *deck ;
    VOIDPTR data ;
Function:
    Add a new element to bottom of the deck.  User is required to maintain
    memory of the data element.
*/

extern VOIDPTR utDdeck_pop( UTDDECK *deck ) ;
/* 
Arguments:
    UTDDECK *deck ;
Function:
    Delete top item from deck.  If item does not exist does nothing unless
    debug switch has been turned on.  User is required to maintain
    memory of the data element.
    Returns data (interger or pointer) stored on card.  
*/

extern VOIDPTR utDdeck_dequeue( UTDDECK *deck ) ;
/* 
Arguments:
    UTDDECK *deck ;
Function:
    Delete bottom item from deck.  If item does not exist does nothing unless
    debug switch has been turned on.  User is required to maintain
    memory of the data element.
    Returns data (interger or pointer) stored on card.  
*/

extern void utDdeck_reverse( UTDDECK *deck ) ;
/* 
Arguments:
    UTDDECK *deck ;
Function:
    Reverses the order of a deck.  It is like fliping a deck of cards
    over and picking them from the other side.  This could also be
    done using utDdeck_pop and UTDdeck_dequeue.  This is just another way.
*/

extern void utDdeck_dump ( UTDDECK *deckPtr, void (*userPrint)(void *) ) ;
/*
Arguments:
    UTDDECK *deckPt ;
    INT (*userPrint)();
Function:
    For each data item in the deck, call the user print function.
*/

extern void utDdeck_empty( UTDDECK *deck, void (*userDelete)(void *) ) ;
/* 
Arguments:
    UTDDECK *deck ;
    (*userDelete)();
Function:
    Frees deck memory. User userdelete function is used to free data
    if desired.  Deck structure remains but links are removed.
    Should be used if deck is to be used again.
*/

extern void utDdeck_free( UTDDECK *deck, void (*userDelete)(void *) ) ;
/* 
Arguments:
    UTDDECK *deck ;
    (*userdelete)();
Function:
    Frees deck memory. User userdelete function is used to free data
*/

extern UTDCARD *utDdeck_sentinel(void) ;
/* Arguments:
    none
Function:
   returns address of deck sentinel.  normally this is not used directly
   by the user.  Use macro YNOTDECKEND
*/

extern  int utDdeck_verify( UTDDECK *deck ) ;

#endif /* INCLUDED_UTD_DECK_H */
