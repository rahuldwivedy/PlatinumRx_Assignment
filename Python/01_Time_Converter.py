def convert_minutes(minutes):
    hours = minutes // 60
    mins = minutes % 60

    if hours > 0 and mins > 0:
        return f"{hours} hr{'s' if hours > 1 else ''} {mins} minute{'s' if mins > 1 else ''}"
    elif hours > 0:
        return f"{hours} hr{'s' if hours > 1 else ''}"
    else:
        return f"{mins} minute{'s' if mins > 1 else ''}"


# Input and error handling
try:
    minutes = int(input("Enter number of minutes: "))

    if minutes < 0:
        print("Minutes cannot be negative.")
    else:
        result = convert_minutes(minutes)
        print("Result:", result)

except ValueError:
    print("Please enter a valid integer.")