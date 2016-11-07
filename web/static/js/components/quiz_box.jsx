import React from "react"
import ReactDOM from "react-dom"
import { Router, Route, Link } from "react-router"
var $ = require('jquery')

class QuizBox extends React.Component {
  render() {
    return (<h1>Quiz</h1>)
    this.state = {};
  }

  componentDidMount() {
    this.loadQuizFromServer();
  }

  loadQuizFromServer() {
    $.ajax({
      url: '/api' + window.location.pathname,
      method: 'GET',
      dataType: 'json',
      success: function(data) {
        console.log(data);
      },
      error: function(error) {
        console.log(error);
      }
    })
  }
}

ReactDOM.render(
  <QuizBox/>, document.getElementById("quiz_container")
)
