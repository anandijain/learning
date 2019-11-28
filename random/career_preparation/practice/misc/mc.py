def maxLCS(s):
    """
    the maximum number u could have is where there are n unique chars,
    len(s) % 2 == 0, and len(s) == 2n
    """
    str_dict = {char: [] for char in set(s)}
    for i, char in enumerate(s):
        str_dict[char].append(i)
    max_common = get_LCS(s, str_dict)

    return max_common


def get_LCS(s, d):
    """
    returns the lcs for a given split index
    not fast enough

    binary search? 
    probabilistically, random strings will follow gaussian 
    so it really is worthwhile to start at the middle instead of looping through
    """
    max_common = 0
    str_len = len(s)

    for i in range(str_len):
        commons = 0
        for k, v in d.items():
            on_left = 0
            on_right = 0
            for elt in v:
                if elt <= i:
                    on_left += 1
                elif elt > i:
                    on_right += 1

            commons += min(on_left, on_right)
        if commons > max_common:
            max_common = commons

    return max_common
