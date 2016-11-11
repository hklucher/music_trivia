import React from "react"
import ReactDOM from "react-dom"
import {AnswersBox} from "./answers_box"
import {QuestionsBox} from "./questions_box"

class QuizBox extends React.Component {
  constructor() {
    super();
    this.state = {
      quiz: {},
      score: 0
    };
  }

  componentWillMount() {
    const url = `/api/${window.location.pathname}`;
    fetch(url)
      .then( (response) => {
        return response.json() })
          .then( (json) => {
            this.setState({quiz: json});
          });
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
        <QuestionsBox quiz={this.state.quiz}></QuestionsBox>
      </div>
    )
  }
}


ReactDOM.render(
  <QuizBox/>, document.getElementById("quiz_container")
)
