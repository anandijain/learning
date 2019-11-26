def strangeSort(mapping, nums):
    """
    
    """
    print(nums)
    d_map = {str(n): str(i) for i, n in enumerate(mapping)}
    converted = convert(nums, d_map)
    indices = sorted(range(len(converted)), key=converted.__getitem__)
    ret = [nums[i] for i in indices]
    print(ret)
    return ret


def convert(nums, d_map):
    # construct dict for easy access of correct map val
    converted = []
    converted = [int("".join(d_map[char] for char in str_num)) for str_num in nums]
    return converted
