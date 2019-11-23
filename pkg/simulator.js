//my first p-code simulator
/*
what we should have in this S_machine
1.code  
2.namespace_chain
3.stack
*/
const NIL = new Symbol() //represent declared but with no value
const VAR_ALREADY_DECLARED = new Symbol()//to tell the usr that this var is already declared in the CURRENT namespace
const UNDEFINED = new Symbol()
const VAR_NOT_DECLARED = new Symbol()

/*
  1.  push: u could push a value or push a name, if its a name then you need to find the name 
  2.  pop: basically this will simply discard the top item from the stack, but
  3.  
  4.
*/
function S_machine(){
  this.eip = 0 //eip
  this.codes = []//
  this._stack = new S_stack()
  this.cur_namespace = new S_namespace(null)
  this.func_namespace = new S_namespace(null)
}

S_machine.prototype.push = function(val){
  this._stack.push(val)
}

S_machine.prototype.pop = function(name = NIL){
  let o = this._stack.pop()
  if (name === NIL)
    return 
  if ( this.cur_namespace.set(name,o) == VAR_NOT_DECLARED )
    throw new Error("var not declared before")
  return
}


function S_stack(){
  //i cannot imagine a simpler stack implementation
  this._stack = []
}

S_stack.prototype.push = function(o){
  this._stack.push(o)
}

S_stack.prototype.pop = function(){
  if (this._stack.length == 0)
    throw new Error("The stack is already empty!")
  return this._stack.pop()
}
//simple namespace implementation
//this namespace actually represent a chain by the usage of "pre" field
function S_namespace (pre){ // if this is the first then the pre will be null
  this._map = new Map()
  this._pre = pre //pre could be another S_namespace instance or NULL
}

S_namespace.prototype.declare = function(k){
  this._map.set(k,NIL)
}

S_namespace.prototype.set = function(k,v){
  let n = this._find(k)
  if (n == VAR_NOT_DECLARED)
    return n
  return n._map.set(k,v)
}

S_namespace.prototype.get = function(k){
  let n = this._find(k)
  if (n == VAR_NOT_DECLARED)
    return NIL
  return n._map.get(k)
}


/*
find the first namespace on the chain which has the k already declared
this will be utilized by the getter and setter
*/
S_namespace.prototype._find = function(k){
  let cur = this
  while(cur != null){
    if (cur._map.has(k))
      return cur
    cur = cur._pre
  }
  return VAR_NOT_DECLARED
}

S_namespace.prototype.isCurDeclared = function(k){//check whether this is declared in current namespace
  return this._map.has(k)
}






