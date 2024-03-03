// SPDX-License-Identifier: MIT
pragma solidity 0.8.18; // @follow-up - [Version update?] This is not the latest version --> verify if we need to update.

/*
 * @author not-so-secure-dev
 * @title PasswordStore
 * @notice This contract allows you to store a private password that others won't be able to see.
 * You can update your password at any time.
 */
contract PasswordStore {
    error PasswordStore__NotOwner(); // @audit-info - Custom Error to verify `getPassword()` is called by the owner

    /*//////////////////////////////////////////////////////////////
                            STATE VARIABLES
    //////////////////////////////////////////////////////////////*/

    address private s_owner; // @audit-info - Used in the contructor to store `msg.sender`
    string private s_password; // @audit-info - Used to both (a) hold, in setPass and (b) retreive, in getPass // @audit-issue [3] While 'private' this is not hidden and can be read publicly.

    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/

    event SetNetPassword();

    constructor() {
        s_owner = msg.sender;
    }

    /*
     * @notice This function allows only the owner to set a new password. //@audit - Invariant "only the owner" --> so can someone other than the owner set a new password?
     * @param newPassword The new password to set.
     */
    function setPassword(string memory newPassword) external {
        // @audit-issue [1] - [Access Control] Others other than the owner can set the password, as there is not a check for who is able to call this function
        s_password = newPassword;
        emit SetNetPassword();
    }

    /*
     * @notice This allows only the owner to retrieve the password. // @audit-ok - There is a check for this invariant (only the owner)
     * @param newPassword The new password to set. // @audit-issue [2] - There is not a newPassword param
     */
    function getPassword() external view returns (string memory) {
        if (msg.sender != s_owner) {
            revert PasswordStore__NotOwner();
        }
        return s_password;
    }
}
