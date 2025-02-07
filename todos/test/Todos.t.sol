// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {Todos} from "../src/Todos.sol";

contract TodosTest is Test {
    Todos public sampleTodos;
    Todos.TodoItem public EMPTY_TODO = Todos.TodoItem(0, "", "", false, address(0));

    function setUp() public {
        sampleTodos = new Todos();
    }

    function testCreateTodos() public {
        string memory todoTitle = "Todo Title";
        string memory todoDescription = "Todo Description";
        sampleTodos.createTodo(todoTitle, todoDescription);
        Todos.TodoItem memory todoItem = sampleTodos.getTodo(1);
        assert(keccak256(abi.encodePacked(todoItem.todoTitle)) != keccak256(abi.encodePacked(EMPTY_TODO.todoTitle)));
        assert(keccak256(abi.encodePacked(todoItem.todoDescription)) != keccak256(abi.encodePacked(EMPTY_TODO.todoDescription)));
    }

    function testUpdateTodos() public {
        sampleTodos.createTodo("Old Title", "Old Description");
        sampleTodos.updateTodo(1, "New Title", "New Description");
        Todos.TodoItem memory todoItem = sampleTodos.getTodo(1);
        assert(keccak256(abi.encodePacked(todoItem.todoTitle)) == keccak256(abi.encodePacked("New Title")));
        assert(keccak256(abi.encodePacked(todoItem.todoDescription)) == keccak256(abi.encodePacked("New Description")));
    }

    function testDeleteTodos() public {
        sampleTodos.createTodo("Todo Title", "Todo Description");
        sampleTodos.deleteTodo(1);
        Todos.TodoItem memory todoItem = sampleTodos.getTodo(1);
        assert(keccak256(abi.encodePacked(todoItem.todoTitle)) == keccak256(abi.encodePacked(EMPTY_TODO.todoTitle)));
        assert(keccak256(abi.encodePacked(todoItem.todoDescription)) == keccak256(abi.encodePacked(EMPTY_TODO.todoDescription)));
    }
}
