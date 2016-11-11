import React from "react"
import ReactDOM from "react-dom"
import {Question} from "./question"

export class QuestionsBox extends React.Component {
  constructor(props) {
    super(props);
    this.state = {loading: "Loading..."};
  }

  render() {
    if (this.props.quiz.questions) {
      var questionsList = this.props.quiz.questions.map(function(question) {
        return (
            <li key={question.id}>
              <Question content={question.content} responses={question.responses}/>
            </li>
          )
      })
      return (
        <ul>
          {questionsList}
        </ul>
      )
    } else {
      return(<div>{this.state.loading}</div>);
    }
  }

}
