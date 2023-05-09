const duplicateCharactersAllowed = false;
# const illegalCharacters;

function testRadiceConversion()
    outRadix::Array{Char}=['A','T','G','5','S']
    inRadix::Array{Char}=['a','b','c','d','e','f','g']
    input::Array{Char}=['a','d','e','d','c','f','c','g','b']
    result = radicesConvert(input,inRadix,outRadix)
    lengthOfResult = length(result)
    println("the result is of length $lengthOfResult and is $result")
end

function radicesConvert(input::Array{Char}, inRadix::Array{Char}, outRadix::Array{Char})

    function add(x::Array{Int}, y::Array{Int}, base::Int)
        z::Array{Int}=[]
        n::Int = max(length(x),length(y))
        carry::Int = 0
        i::Int = 0
        l=length(x)
        while i < n || carry > 0
            xi = i < length(x) ? x[i+1] : 0
            yi = i < length(y) ? y[i+1] : 0
            zi = carry + xi + yi

            push!(z,(zi % base))
            carry = floor(zi / base)
            i+=1
        end
        return z
    end
    function multiplyByNumber(num::Int, power::Array{Int}, base::Int)
        if num==0
            println("num was 0")
            return [0]
        end
        result::Array{Int}=[]
        while true
            if num & 1 > 0
                result = add(result,power,base)
            end
            num = num >> 1
            if num == 0
                break
            end
            power = add(power,power,base)
        end
        return result
    end

    # creates an array based on the input with the indexes of the corresponding values on inRadix
    function decodeInput()
        result::Array{Int}=[]
        for i in reverse(1:length(input))
            push!(result,(findfirst(isequal(input[i]),inRadix))-1)

            index = findfirst(isequal(input[i]),inRadix)-1
            println(index)

        end
        return result
    end

    fromBase = length(inRadix)
    toBase = length(outRadix)
    digits = decodeInput()
    outArray::Array{Int}=[]
    power::Array{Int}=[1]

    for i in 1:length(digits)
        outArray = add(outArray,multiplyByNumber(digits[i],power,toBase),toBase)
        println("outarray is $outArray")
        power = multiplyByNumber(fromBase,power,toBase)
    end

    out::Array{Char}=[]
    for i in reverse(1:length(outArray))
        push!(out,outRadix[outArray[i]+1])
    end
    return out
end
testRadiceConversion()

# if same size bases, the delta is 0
# if the output base is larger than the input base, the delta is 1?
# how is the outbase%inbase remainder relevant to inputcharlength and fraction between them
