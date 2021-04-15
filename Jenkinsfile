elifeLibrary {
    stage 'Checkout', {
        checkout scm
    }

    stage 'Project tests', {
        elifeLocalTests "./project_tests.sh"
    }

    // 'Mainline' is the project's default branch. In this case, it is "develop".
    elifeMainlineOnly {
    
        // develop -> approved
        // "approved" branch and spectrum testing typically used on larger projects, not libraries.
        stage 'Approval', {
            elifeGitMoveToBranch elifeGitRevision(), 'approved'
        }

        // end2end/spectrum tests here typically

        // approved -> master
        stage 'Master', {
            elifeGitMoveToBranch elifeGitRevision(), 'master'
        }
    }
}
