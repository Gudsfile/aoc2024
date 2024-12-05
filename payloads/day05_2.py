import re
from functools import cmp_to_key

DATASET_PATH = "datasets/day05.txt"


def extract_rules(raw):
    rules_regex = re.compile("(\d{2})\|(\d{2})$")
    rules = {}
    for rule in filter(rules_regex.match, raw):
        key, value = map(int, rule.split("|"))
        rules.setdefault(key, []).append(value)
    return rules


def extract_updates(raw):
    updates_regex = re.compile("(\d{2},)+\d{2}$")
    return [list(map(int, update.replace("\n", "").split(","))) for update in filter(updates_regex.match, raw)]


def sort_update(update, rules):
    def compare(x, y):
        if x in rules.get(y, []):
            # print(f"{x} should be after before {y}")
            return 1
        if y in rules.get(x, []):
            # print(f"{x} should be sorted before {y}")
            return -1
        # print(f"{x} and {y} should be ordered equally")
        return 0

    return sorted(update, key=cmp_to_key(compare))


def main():
    raw = open(DATASET_PATH, "r").readlines()
    rules = extract_rules(raw)
    updates = extract_updates(raw)

    sorted_incorrectly_ordered_updates = [
        sorted_update for update in updates if (sorted_update := sort_update(update, rules)) != update
    ]

    print(sum([update[len(update) // 2] for update in sorted_incorrectly_ordered_updates]))


if __name__ == "__main__":
    main()
