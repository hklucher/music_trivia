import React from "react"
import ReactDOM from "react-dom"
import {AnswersBox} from "./answers_box"
import {QuestionsBox} from "./questions_box"

class QuizBox extends React.Component {
  constructor() {
    super();
    this.state = {quiz: {}};
  }

  componentWillMount() {
    this.loadQuizFromServer();
  }

  shouldComponentUpdate(nextProps, nextState) {
    if (nextState.quiz.name) {
      return true;
    } else {
      return false;
    }
  }

  render() {
    return (
      <div>
        <h1>{this.state.quiz.name}</h1>
        <QuestionsBox questions={this.state.quiz.questions}></QuestionsBox>
      </div>
    )
  }

  loadQuizFromServer() {
    const url = '/api' + window.location.pathname;
    const _this = this;
    return fetch(url, {
        method: 'get',
        datatype: 'json'
      }).then(function(response) {
          response.json().then(function(data) {
            _this.setState({quiz: data})
          });
      }).catch(function(err) {
          console.log(err)
      });
  }
}


ReactDOM.render(
  <QuizBox/>, document.getElementById("quiz_container")
)
