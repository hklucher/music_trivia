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
      currentQuestion: {},
      completed: false,
      currentQuestionNumber: 1,
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
    if (!this.state.completed) {
      var questionLength;
      if (this.state.quiz.questions) {
        questionLength = this.state.quiz.questions.length;
      }
      return (
        <div>
          <h1 className="serif">{this.state.quiz.name}</h1>
          <p>Question {this.state.currentQuestionNumber}/{questionLength}</p>
          <Question
            content={this.state.currentQuestion.content}
            responses={this.state.currentQuestion.responses}
            handleSubmit={this.handleQuestionSubmit.bind(this)}>
          </Question>
        </div>
      )
    } else {
      return (
        <div>
          <h1>
            Quiz Completed!
          </h1>
          <p>
            You got {this.state.score} out of {this.state.quiz.questions.length} possible!
          </p>
        </div>
      )
    }
  }

  handleQuestionSubmit(questionResult) {
    if (questionResult) {
      let currentScore = this.state.score;
      this.setState({score: currentScore + 1});
    }
    this._markQuestionComplete();
    let nextQuestion = this._getNextQuestion();
    this.setState({currentQuestion: nextQuestion});
    let nextQuestionNumber = this.state.currentQuestionNumber + 1;
    this.setState({currentQuestionNumber: nextQuestionNumber});
  }

  _markQuestionComplete() {
    let currentCompletedQuestions = this.state.completedQuestions.slice();
    currentCompletedQuestions.push(this.state.currentQuestion);
    this.setState({completedQuestions: currentCompletedQuestions});
  }

  _getNextQuestion() {
    let currentQuestionId = this.state.currentQuestion.id
    for (var i = 0; i < this.state.quiz.questions.length; i ++) {
      if (this.state.quiz.questions[i].id === currentQuestionId) {
        let nextQuestion = this.state.quiz.questions[i + 1];
        if (this.state.quiz.questions.length === i + 1) {
          this.setState({completed: true});
        } else {
          return this.state.quiz.questions[i + 1];
        }
      }
    }
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
