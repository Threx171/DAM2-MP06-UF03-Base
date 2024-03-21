declare option output:method "xml";
declare option output:indent "yes";

<questions>{
  for $question in doc("gaming.stackexchange/Posts.xml")//row
  let $title := $question/@Title
  let $viewCount := xs:integer($question/@ViewCount)
  order by $viewCount descending
  return
    <question>
      <title>{$title}</title>
      <viewCount>{$viewCount}</viewCount>
    </question>
}</questions>
