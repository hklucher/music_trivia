import React from "react"
import ReactDom from "react-dom"

export class Question extends React.Component {
  constructor(props) {
    super(props);
    this.state = {};
  }

  render() {
    return(<p>{this.props.content}</p>)
  }
}
