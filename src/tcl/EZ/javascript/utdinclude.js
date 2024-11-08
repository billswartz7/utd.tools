function getPI() {
   return getVar("pluginInstance");
}


function write(msg) {
  JS_HTML(msg) ;
}

function make_doc( ) {
  this.write = write ;
}

document = new make_doc( ) ;

function UTDsection(section) {
}

function js_include_search_results( ) {
  path = JSevalTcl( "ezsearch_tmppath" ) ;
  html = "<SCRIPT SRC=\"" + path + "\"></SCRIPT>" ;
  JS_HTML( html ) ;
}
