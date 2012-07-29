console.log "Start watching files"

itemsList =
   pierwszy : 1
   drugi    : 2
   trzeci   : 3

arrayList = [
    'a'
    'b'
    'c'
    'd'
]
    
# regular loop
for item, key in arrayList
    console.log("#{item} -- #{key}")

# regular loop
for key, item of itemsList
    console.log(item)

# loop which export items to array
result = (item for item of itemsList)
console.log result

# filter loop
result = (item for item of itemsList when item >=2)

# assing into two category
passed = []
failed = []
(if item > 2 then passed else failed).push item for item of itemsList
# equals :
for item of itemsList
    (if item > 2 then passed else failed).push item
    console.log(item)

# test for existance
included = 2 in itemsList
console.log included

# existential operator
hash = "string"
console.log(hash ?= "empty value")
hash = null
console.log(hash ?= "empty value")

# deconstructing assignments
someObject = { a: 'value for a', b: 'value for b' }
{ a, b } = someObject
console.log "a is '#{a}', b is '#{b}'"

# execute function immediately
type = do ->
    classToType = {}
    for name in "Boolean Number String Function Array Date RegExp Undefined Null".split(" ")
        classToType["[object #{name} ]"] = name.toLowerCase()

    # return a function
    (obj) ->
        strType = Object::toString.call(obj)
        classToType[strType] or "object"





