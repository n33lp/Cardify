def validate_pass(stringToValidate):
    r1 = any(chr.isdigit() for chr in stringToValidate)
    r2 = any(chr.isupper() for chr in stringToValidate)
    r3 = any(chr.islower() for chr in stringToValidate)
    r4 = any(not chr.isalnum() for chr in stringToValidate)
    r5 = len(stringToValidate) >= 8

    if r1 and r2 and r3 and r4 and r5:
        return True    
    return False

# Test cases
def test_validate_pass():
    # Test case 1: All conditions are met
    assert validate_pass("Abcd123!") == True

    # Test case 2: Missing uppercase character
    assert validate_pass("abcd123!") == False

    # Test case 3: Missing lowercase character
    assert validate_pass("ABCD123!") == False

    # Test case 4: Missing digit
    assert validate_pass("Abcdefg!") == False

    # Test case 5: Missing special character
    assert validate_pass("Abcd1234") == False

    # Test case 6: Password length less than 8
    assert validate_pass("Abc123!") == False

    # Test case 7: Empty password
    assert validate_pass("") == False

    # Test case 8: Only digits
    assert validate_pass("12345678") == False

    # Test case 9: Only uppercase letters
    assert validate_pass("ABCDEFGH") == False

    # Test case 10: Only lowercase letters
    assert validate_pass("abcdefgh") == False

    print("All test cases pass")

test_validate_pass()