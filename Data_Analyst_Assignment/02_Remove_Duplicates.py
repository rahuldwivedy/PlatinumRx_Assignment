D.2 Remove duplicate characters from a string (keep first occurrence), using a loop
/*def unique_string_preserve_order(s: str) -> str:
    seen = set()
    result_chars = []
    for ch in s:
        if ch not in seen:
            seen.add(ch)
            result_chars.append(ch)
    return ''.join(result_chars)


print(unique_string_preserve_order("aabbccab"))   # "abc"
print(unique_string_preserve_order("banana"))      # "ban"*/