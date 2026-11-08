Title: Adding a new OpenTofu provider: the flowchart
Slug: opentofu-new-provider-flowchart
Status: hidden

This is the flowchart for the checklist in [Using OpenTofu to manage your Infrastructure as Code]({filename}/technology/using-opentofu-to-manage-your-infrastructure-as-code.md#a-checklist-for-adding-a-new-provider). The section numbers match the checklist. `op run --env-file=.env --` is 1Password's runner; use your own secrets manager's equivalent.

```mermaid
flowchart TD
    start(["Start"]) --> discover["Discover what exists<br/>(section 1)"]
    discover --> bail1{"Account empty<br/>or not yours?"}
    bail1 -- yes --> stop1(["Bail out"])
    bail1 -- no --> vet["Vet the provider<br/>(section 2)"]
    vet --> bail2{"Can't import, Read only checks<br/>existence, or unmaintained?"}
    bail2 -- yes --> stop2(["Bail out"])
    bail2 -- no --> creds["Store a scoped token<br/>in the secrets manager<br/>(section 3)"]
    creds --> scaffold["Create a branch and #lt;module#gt;/ with<br/>versions.tf, providers.tf, variables.tf, .env<br/>(section 4)"]
    scaffold --> init["op run --env-file=.env --<br/>tofu init"]

    subgraph sg_import["Import, one resource type at a time (section 5)"]
        init --> imp["Add import {} blocks"]
        imp --> gen["op run --env-file=.env --<br/>tofu plan -generate-config-out=generated.tf"]
        gen --> tidy["Clean up generated config,<br/>move it into #lt;kind#gt;.tf"]
        tidy --> plan["op run --env-file=.env --<br/>tofu plan"]
        plan --> review{"Only imports?<br/>0 to add / change / destroy"}
        review -- "no, fixable" --> tidy
        review -- "no, can't fix" --> stop3(["Bail out:<br/>delete imports.tf"])
        review -- yes --> apply["op run --env-file=.env --<br/>tofu apply"]
        apply --> cleanup["Delete imports.tf,<br/>plan shows no changes"]
        cleanup --> more{"Another resource<br/>type to import?"}
        more -- yes --> imp
    end

    more -- no --> ship["Update README, tofu fmt -check,<br/>commit with .terraform.lock.hcl, open a PR<br/>(section 7)"]
    ship --> done(["Done"])
```

Every change after that (an edit, a rename, a provider upgrade from section 6) follows the same loop:

```mermaid
flowchart LR
    edit["Edit config"] --> check["tofu fmt<br/>tofu validate"]
    check --> plan["tofu plan"]
    plan --> ok{"What you<br/>expected?"}
    ok -- no --> edit
    ok -- yes --> apply["tofu apply"]
    apply --> clean{"Any changes<br/>left in tofu plan?"}
    clean -- yes --> edit
    clean -- no --> pr["Commit, open a PR"]
```
