import React from "react"
import ReactDOM from "react-dom"
import {AnswersBox} from "./answers_box"
import {QuestionBox} from "./question_box"
import {Question} from "./question"

class QuizBox extends React.Component {
  constructor() {
    super();
    this.state = {
      quiz: {},
      score: 0,
      completedQuestions: [],
      currentQuestion: {}
    };
  }

  componentWillMount() {
    const url = `/api/${window.location.pathname}`;
    fetch(url)
      .then((response) => {
        return response.json() })
          .then((json) => {
            this.setState({quiz: json, currentQuestion: json.questions[0]});
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
    console.log(this.state.currentQuestion);
    return (
      <div>
        <h1>{this.state.quiz.name}</h1>
        <QuestionBox
          content={this.state.currentQuestion.content}
          responses={this.state.currentQuestion.responses}>
        </QuestionBox>
      </div>
    )
  }

  adjustScore(current, correct) {
    if (current === correct) {
      this.setState({score: this.state.score + 1})
    }
  }
}


ReactDOM.render(
  <QuizBox/>, document.getElementById("quiz_container")
)
