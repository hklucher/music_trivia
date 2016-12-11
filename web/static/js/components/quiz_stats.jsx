import React from "react"
import ReactDOM from "react-dom"
import {QuestionList} from "./question_list"

export class QuizStats extends React.Component {
  constructor(props) {
    super(props);
    this.state = {postedResults: false};
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
        {this._displayPostResultsLink()}
      </div>
    )
  }

  _displayPostResultsLink() {
    if (this.state.postedResults) {
      return <a href="#">Results added! Click to view your profile</a>;
    } else {
      return <a href="#" onClick={this._handlePostResults.bind(this)}>Click to add your results to your profile</a>; 
    }
  }

  _handlePostResults(e) {
    e.preventDefault();
    fetch(`/api/users/${this.props.userId}/completed_quizzes`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        completed_quiz: {
          // JSON body! 
        }
      })
    })
  }
}

QuizStats.propTypes = {
  questions: React.PropTypes.array,
  numberCorrect: React.PropTypes.number,
  quizName: React.PropTypes.string
}
