import React from "react"
import ReactDom from "react-dom"
import {ResponsesBox} from "./responses_box"

export class Question extends React.Component {
  constructor(props) {
    super();
    this.state = {};
  }

  render() {
    return (
      <div>
        <p>{this.props.content}</p>
        <ResponsesBox responses={this.props.responses}></ResponsesBox>
      </div>
    )
  }
}
