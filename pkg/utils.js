argSlicer = function(_args){//transform arg tree ==> arg vector
  let out = [];
  function go(tree){
    if ( tree.left && tree.left.type == "p_args" ) go (tree.left);
    out.push(tree.right)
  }
  go(_args)
  return out
}