// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.20;

contract Todos {
    struct TodoItem {
        uint256 todoID;
        string todoTitle;
        string todoDescription;
        bool completed;
        address todoOwner;
    }

    mapping(uint256 => TodoItem) public todos;
    mapping(address => TodoItem[]) public ownerToTodos;

    uint256 public todoIncrement = 1;
    TodoItem public EMPTY_TODO = TodoItem(0, "", "", false, address(0));

    event TodoCreated(uint256 indexed todoId, address indexed owner);
    event TodoUpdated(uint256 indexed todoId);
    event TodoDeleted(uint256 indexed todoId);
    event TodoCompleted(uint256 indexed todoId, bool completed);

    constructor() {
        todos[0] = EMPTY_TODO;
    }

    /// @notice Creates a new todo item
    /// @param _todoTitle The title of the todo
    /// @param _todoDescription The description of the todo
    function createTodo(string memory _todoTitle, string memory _todoDescription) public {
        uint256 todoId = todoIncrement++;
        TodoItem memory todoItem = TodoItem(todoId, _todoTitle, _todoDescription, false, msg.sender);
        todos[todoId] = todoItem;
        ownerToTodos[msg.sender].push(todoItem);
        emit TodoCreated(todoId, msg.sender);
    }

    /// @notice Updates an existing todo
    /// @param _todoId The ID of the todo to update
    /// @param _todoTitle The new title
    /// @param _todoDescription The new description
    function updateTodo(uint256 _todoId, string memory _todoTitle, string memory _todoDescription) public {
        require(_todoId < todoIncrement, "Todo item does not exist!");
        TodoItem storage todoItem = todos[_todoId];
        require(todoItem.todoOwner == msg.sender, "Only the owner can update this todo!");
        todoItem.todoTitle = _todoTitle;
        todoItem.todoDescription = _todoDescription;
        emit TodoUpdated(_todoId);
    }

    /// @notice Deletes a todo
    /// @param _todoId The ID of the todo to delete
    function deleteTodo(uint256 _todoId) public {
        require(_todoId < todoIncrement, "Todo item does not exist!");
        TodoItem storage todoItem = todos[_todoId];
        require(todoItem.todoOwner == msg.sender, "Only the owner can delete this todo!");
        require(
            !compareStrings(todoItem.todoTitle, EMPTY_TODO.todoTitle) &&
            !compareStrings(todoItem.todoDescription, EMPTY_TODO.todoDescription),
            "Todo is already empty."
        );
        todos[_todoId] = EMPTY_TODO;
        emit TodoDeleted(_todoId);
    }

    /// @notice Toggles completion status of a todo
    /// @param _todoId The ID of the todo to toggle
    function toggleComplete(uint256 _todoId) public {
        require(_todoId < todoIncrement, "Todo item does not exist!");
        TodoItem storage todoItem = todos[_todoId];
        require(todoItem.todoOwner == msg.sender, "Only the owner can modify completion status!");
        todoItem.completed = !todoItem.completed;
        emit TodoCompleted(_todoId, todoItem.completed);
    }

    /// @notice Returns all todos of the caller
    function getMyTodos() public view returns (TodoItem[] memory) {
        return ownerToTodos[msg.sender];
    }

    /// @notice Returns a specific todo item
    /// @param _todoId The ID of the todo to retrieve
    function getTodo(uint256 _todoId) public view returns (TodoItem memory) {
        return todos[_todoId];
    }

    /// @notice Compares two strings (helper function)
    function compareStrings(string memory a, string memory b) internal pure returns (bool) {
        return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b));
    }
}
