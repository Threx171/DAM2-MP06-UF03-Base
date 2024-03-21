declare option output:method "xml";
declare option output:indent "yes";

<topQuestionsWithTopAnswers>{
  let $questions :=
    for $question in doc("gaming.stackexchange/Posts.xml")//row[@PostTypeId = '1']
    let $score := xs:integer($question/@Score)
    order by $score descending
    return $question

  for $question in $questions[position() <= 10]
  let $questionTitle := $question/@Title
  let $questionBody := $question/@Body
  let $questionTags := $question/@Tags
  let $questionScore := xs:integer($question/@Score)
  let $answers :=
    for $answer in doc("gaming.stackexchange/Posts.xml")//row[@PostTypeId = '2' and @ParentId = $question/@Id]
    let $answerScore := xs:integer($answer/@Score)
    order by $answerScore descending
    return $answer
  let $topAnswer := $answers[1]
  let $topAnswerBody := $topAnswer/@Body
  let $topAnswerVotes := xs:integer($topAnswer/@Score)
  return
    <question>
      <title>{$questionTitle}</title>
      <body>{$questionBody}</body>
      <tags>{$questionTags}</tags>
      <score>{$questionScore}</score>
      <topAnswer>
        <body>{$topAnswerBody}</body>
        <votes>{$topAnswerVotes}</votes>
      </topAnswer>
    </question>
}</topQuestionsWithTopAnswers>
