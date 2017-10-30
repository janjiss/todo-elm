'use strict';

require("./styles.scss");

var Elm = require('./Todo');

var storedState = localStorage.getItem('elm-todo-save');
var startingState = storedState ? JSON.parse(storedState) : null;

var todomvc = Elm.Todo.fullscreen(startingState);

todomvc.ports.setStorage.subscribe(function(state) {
    localStorage.setItem('elm-todo-save', JSON.stringify(state));
});