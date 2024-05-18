def validate_pass(stringToValidate):
    r1 = any(chr.isdigit() for chr in stringToValidate)
    r2 = any(chr.isupper() for chr in stringToValidate)
    r3 = any(chr.islower() for chr in stringToValidate)
    r4 = any(not chr.isalnum() for chr in stringToValidate)
    r5 = len(stringToValidate) >= 8
    if r1 and r2 and r3 and r4 and r5:
        return True    
    return False


def test_validate_pass():
    assert validate_pass("Abcd123!") == True
    assert validate_pass("abcd123!") == False
    assert validate_pass("ABCD123!") == False
    assert validate_pass("Abcdefg!") == False
    assert validate_pass("Abcd1234") == False
    assert validate_pass("Abc123!") == False
    assert validate_pass("") == False
    assert validate_pass("12345678") == False
    assert validate_pass("ABCDEFGH") == False
    assert validate_pass("abcdefgh") == False
    print("All test cases pass")

test_validate_pass()