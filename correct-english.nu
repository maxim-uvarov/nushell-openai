use openai.nu results_record

export def main [
    prompt: string
] {
    let $prompt_with_tick = $prompt | str replace -a '●' '`'
    let $answer = (
        results_record --system "Edit the message and correct grammar. Provide only the edited message. Don't change markdown markup." $prompt_with_tick
    )

    let filename = (now-fn)

    $prompt_with_tick | save $'/Users/user/temp/llms/prompt(now-fn).txt'
    $answer | save $'/Users/user/temp/llms/answer(now-fn).txt'

    $answer | pbcopy

    codium --diff $'/Users/user/temp/llms/prompt($filename).txt' $'/Users/user/temp/llms/answer($filename).txt'
}

def 'now-fn' [
    --pretty (-P)
] {
    date now
    | if $pretty {
        format date '%Y-%m-%d-%H:%M:%S'
    } else {
        format date '%Y%m%d-%H%M%S'
    }
}
