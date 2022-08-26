
def nested_object(object,key):
    output = {}
    if key == "a":
        output=(object["a"])
        return output
    elif key == "b":
        output=(object["a"]["b"])
        return output

    else:
        output=(object["a"]["b"]["c"])
        return output


 
print(nested_object({"a":{"b":{"c":"d"}}}, "b"))





    
    
