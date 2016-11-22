import React from "react"
import ReactDOM from "react-dom"
import {QuestionList} from "./question_list"

export class QuizStats extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    return(
      <QuestionList questions={this.props.questions}/>
    )
  }
}

QuizStats.propTypes = {
  questions: React.PropTypes.array
}
