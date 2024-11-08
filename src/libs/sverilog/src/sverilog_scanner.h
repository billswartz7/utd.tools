
#ifndef H_SVERILOG_SCANNER_H
#define H_SVERILOG_SCANNER_H

#ifndef YY_TYPEDEF_YY_SIZE_T
#define YY_TYPEDEF_YY_SIZE_T
typedef size_t yy_size_t;
#endif

#ifndef YY_BUF_SIZE
    #define YY_BUF_SIZE 16384
#endif

typedef struct yy_buffer_state *YY_BUFFER_STATE;
extern void sverilog__switch_to_buffer (YY_BUFFER_STATE new_buffer ) ;
extern YY_BUFFER_STATE sverilog__create_buffer (FILE *file,int size  );


#endif /* H_SVERILOG_SCANNER_H */
