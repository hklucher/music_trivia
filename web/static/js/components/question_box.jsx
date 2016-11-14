import React from "react"
import ReactDOM from "react-dom"
import {Question} from "./question"

export class QuestionBox extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      loading: 'Loading...',
      currentAnswer: ''
    };
  }

  render() {
    return (
      <div>
        <Question
          content={this.props.content}
          responses={this.props.responses}>
        </Question>
      </div>
    )
  }

  handleChange(currentAnswer, correctAnswer) {
    this.setState({currentAnswer: currentAnswer, correctAnswer: correctAnswer});
    this.props.adjustScore(currentAnswer, correctAnswer)
  }
}
