import React from "react"
import ReactDOM from "react-dom"
import {QuestionList} from "./question_list"

export class QuizStats extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    return(
      <div>
        <div>
          <h1 className="serif">Report: {this.props.quizName}</h1>
          <p>
            You got <strong>{this.props.numCorrect}</strong> out of
            <strong>{this.props.questions.length}</strong> possible.
          </p>
        </div>
        <QuestionList
          questions={this.props.questions}>
        </QuestionList>
        <a href="/">Home</a>
        <a href="/api/completed_quizzes" onClick={this.handleCompletedQuizClick.bind(this)}>Want to record your results?</a>
      </div>
    )
  }

  handleCompletedQuizClick(e) {
    e.preventDefault();
    const completedQuiz = {
      "completed_quiz": {
        "name": this.props.quizName,
        "score": this.props.numCorrect,
        "total_questions": this.props.questions.length
      }
    }

    fetch("/api/completed_quizzes", {
      method: 'POST',
      body: completedQuiz
    }).then(function(resp) { return res.json(); });
  }
}

QuizStats.propTypes = {
  questions: React.PropTypes.array,
  numberCorrect: React.PropTypes.number,
  quizName: React.PropTypes.string
}
