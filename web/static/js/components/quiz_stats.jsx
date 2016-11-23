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
          questions={this.props.questions}
          quizName={this.props.quizName}>
        </QuestionList>
      </div>
    )
  }
}

QuizStats.propTypes = {
  questions: React.PropTypes.array,
  numberCorrect: React.PropTypes.number
}
