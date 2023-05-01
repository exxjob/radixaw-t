const duplicateCharactersAllowed = false;
# const illegalCharacters;
function radicesConvert(input::Array{T,1}, inRadix::Array{T,1}, outRadix::Array{T,1})
    function add (x::Array{Int,1}, y::Array{Int,1}, base::Int)
        z::Array{Int,1}
        n::Int = max(x.length,length(y))
        carry::Int = 0
        i::Int = 0
        while i < n || carry > 0
            xi = i < x.length ? x[i] : 0
            yi = i < y.length ? y[i] : 0
            zi = carry + xi + yi
            z.append!(zi % base)
            carry = (zi / base).floor()
            i+=1
        end
    end


    function multiplyByNumber (num::Int, power::Array{Int,1}, base::Int)
        if num==0
            return [0]
        end
        result::Array{Int,1}
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
    function decodeInput ()
        result::Array{Int,1}
        for i in input.length:1
            result.append!(inRadix.find(input[i]))
        end
        return result
    end

    digits = decodeInput()
    outArray::Array{Int,1}
    power::Array{Int,1}[1]

    for i in 1:digits.length
        outArray = add()
        power = multiplyByNumber()
    end

    out::Array{T,1}
    for i in outArray:1
        out.append!(outRadix[outArray[i]])
    end
    return out

end
