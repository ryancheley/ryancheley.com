Title: PSQL and JSON filtering
Date: 2021-08-15
Tags: psql, json
Slug: psql-and-json-filtering
Authors: ryan
Status: Draft

The need: filter a json field



The SQL:

    select a.score
    , b.first_name
    , b.last_name
    from resumes_resume a
    inner join candidates_candidate b on a.candidate_id = b.id
    left join employees_employee c on b.id = c.candidate_id
    where cast(to_jsonb(score -> 'score' ->> 'Excel'::text) #>> '{}' as integer) >0
    and cast(to_jsonb(score -> 'score' ->> 'SQL'::text) #>> '{}' as integer) >0
    and cast(to_jsonb(score -> 'score' ->> 'Team'::text) #>> '{}' as integer) >0
    and cast(to_jsonb(score -> 'score' ->> 'Me'::text) #>> '{}' as integer) =0
    and c.id is null;
