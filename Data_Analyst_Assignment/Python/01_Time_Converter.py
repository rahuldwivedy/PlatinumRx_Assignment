D.1 Convert minutes into human-readable hours + minutes
/*def format_minutes(total_minutes: int) -> str:
    if total_minutes is None:
        return ""
    hours = total_minutes // 60
    minutes = total_minutes % 60

    parts = []
    if hours:
        # singular/plural
        parts.append(f"{hours} hr" + ("s" if hours > 1 else ""))
    if minutes or not parts:
        parts.append(f"{minutes} minute" + ("s" if minutes != 1 else ""))

    return " ".join(parts)

print(format_minutes(130))  # "2 hrs 10 minutes"
print(format_minutes(110))  # "1 hr 50 minutes" */