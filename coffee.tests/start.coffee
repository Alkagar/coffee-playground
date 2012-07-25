# simple functions
pi = -> 3.14
square = (x) -> x * x
cube   = (y) ->
    cos = square(y) * y
    return cos
filler = (container, liquid = 'tea') ->
    "Filling the #{container} with #{liquid}...."

# arrays
array = ['do', 'it', 'yourself']

# objects
otherArray = {Jagger: 'Rock', Elvis: 'Roll'}
me =
    brother:
        name: 'Max'
        age: 11
    sister:
        name: 'Ida'
        age: 9

# no more quoting reserved words
$('.account').attr
    class: 'active'
log object.class


# variable scopes
outer = 1
changeNumbers = ->
    inner = -1
    outer = 10
inner = changeNumbers()


# if, else
mood = greatlyImproved if singing
if happy and knowsIt
    clapsHands()
    chaChaCha()
else
    showIt()

date = if frideay then sue else jill

# arguments object
gold = silver = rest = "unknown"

awardMedals = (first, second, others...) ->
    gold        = first
    silver      = second
    rest        = others

contenders = ['One', 'Two', 'Three', 'Four', 'Five']
awardMedals contenders...
alert "Gold: " + gold
alert "Silver: " + silver
alert "The Field: " + rest


