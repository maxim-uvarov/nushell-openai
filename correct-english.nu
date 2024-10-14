use openai.nu results_record

export def main [
    prompt: string
] {
    let $prompt_with_tick = $prompt | str replace -a '●' '`'
    let $answer = ( results_record $prompt_with_tick 
        --system "Edit the message and correct grammar. Provide only the edited message. Don't change markdown markup." 
    )

    let filename = (now-fn)

    $prompt_with_tick | save $'/Users/user/temp/llms/prompt($filename).txt'
    $answer | save $'/Users/user/temp/llms/answer($filename).txt'

    $answer | pbcopy

    codium --diff $'/Users/user/temp/llms/prompt($filename).txt' $'/Users/user/temp/llms/answer($filename).txt'
}

def 'now-fn' [
    --pretty (-P)
] {
    date now
    | format date (if $pretty { '%Y-%m-%d-%H:%M:%S' } else { '%Y%m%d-%H%M%S' })
}
