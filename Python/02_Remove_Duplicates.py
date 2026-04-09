def remove_duplicates(s):
    result = ""

    for char in s:
        if char not in result:
            result += char

    return result


# Input and error handling
text = input("Enter a string: ").strip()

if text == "":
    print("Input cannot be empty.")
else:
    result = remove_duplicates(text)
    print("Result:", result)