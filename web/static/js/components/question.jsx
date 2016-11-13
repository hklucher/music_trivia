import React from "react"
import ReactDom from "react-dom"
import {ResponsesBox} from "./responses_box"

export class Question extends React.Component {
  constructor(props) {
    super();
    this.state = {
      answer: '',
      selectedValue: ''
    };
  }

  componentDidMount() {
    this.setState({answer: this.correctAnswer()});
  }

  render() {
    console.log(this.state)
    return (
      <div>
        <p>{this.props.content}</p>
        <ResponsesBox responses={this.props.responses} onChange={this.handleChange} handleChange={this.handleChange.bind(this)}></ResponsesBox>
      </div>
    )
  }

  handleChange(selectedValue) {
    this.setState({selectedValue: selectedValue});
  }

  correctAnswer() {
    for (var i = 0; i < this.props.responses.length; i ++) {
      if (this.props.responses[i].correct) {
        return this.props.responses[i].content;
      }
    }
  }
}
