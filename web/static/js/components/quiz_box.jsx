import React from "react"
import ReactDOM from "react-dom"
var $ = require('jquery')

class QuizBox extends React.Component {
  constructor() {
    super();
    this.state = {quiz: {}};
  }

  render() {
    return (
      <h1>{this.state.quiz.name}</h1>
    )
  }

  componentDidMount() {
    const URL = '/api' + window.location.pathname;
    const _this = this;
    fetch(URL, {
      method: 'get',
      dataType: 'json'
    }).then(function(response) {
        response.json().then(function(data) {
          _this.setState({quiz: data});
        });
    }).catch(function(err) {
        console.log(err)
    });
  }
}

ReactDOM.render(
  <QuizBox/>, document.getElementById("quiz_container")
)
