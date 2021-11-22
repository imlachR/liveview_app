alias Trivium.Repo
alias Trivium.Accounts.User
alias Trivium.Classrooms.{Institution, Classroom, Subject, Lesson, Concept, Content}

# mix ecto.drop && mix ecto.create && mix ecto.migrate && mix run apps/trivium/priv/repo/seeds.exs

Repo.delete_all("subjects")
Repo.delete_all("subscriptions")
Repo.delete_all("classrooms")
Repo.delete_all("users")

Repo.insert!(%User{ name: "Rodrigo Barreto Imlach", email: "rodrimlach@gmail.com", password: "test12345678", hashed_password: Bcrypt.hash_pwd_salt("test12345678"), role: "root"})

Repo.insert!(%Institution{
  name: "codecademy",
  location: "New York, NY",
  classrooms: [
    %Classroom{name: "Web Development",
               prefix: "beginner",
               handle: "@webDev",
      subjects: [
        %Subject{name: "HTML: HyperText Markup Language", slug: "html-#{Enum.random(11..999)}",
          lessons: [
            %Lesson{name: "Head",
              concepts: [
                %Concept{name: "Title and Language", contents: [ %Content{name: "Add a title"}]},
              ]
            }
          ]
        },
        %Subject{name: "CSS: Cascading Style Sheets", slug: "css-#{Enum.random(11..999)}",
          lessons: [
            %Lesson{name: "Background",
              concepts: [
                %Concept{name: "background-color", contents: [ %Content{name: "Add a title"}]},
              ]
            }
          ]
        },
        %Subject{name: "Javascript", slug: "js-#{Enum.random(11..999)}",
          lessons: [
            %Lesson{name: "Functions"}
          ]
        }
      ]
    }
  ]
})

Repo.insert!(%Institution{
  name: "St. Anne's School",
  location: "Miami, FL",
  classrooms: [
      %Classroom{name: "4th grade",
                 prefix: "blue",
                 handle: "@saintAnne401",
        subjects: [
          %Subject{name: "Art", slug: "art-#{Enum.random(11..999)}"},
          %Subject{name: "English", slug: "english-#{Enum.random(11..999)}"},
          %Subject{name: "Science", slug: "science-#{Enum.random(11..999)}"},
          %Subject{name: "History", slug: "history-#{Enum.random(11..999)}",
            lessons: [
              %Lesson{name: "Rome",
                concepts: [
                  %Concept{name: "Timeline of Ancient Rome", contents: [ %Content{name: "Add a title"} ]},
                  %Concept{name: "Early History of Ancient Rome", contents: [ %Content{name: "Add a title"} ]},
                  %Concept{name: "The Roman Republic", contents: [ %Content{name: "Add a title"} ]},
                  %Concept{name: "Republic to Empire", contents: [ %Content{name: "Add a title"} ]},
                  %Concept{name: "The Romans in Britain", contents: [ %Content{name: "Add a title"} ]},
                  %Concept{name: "Ancient Roman Barbarians", contents: [ %Content{name: "Add a title"} ]},
                  %Concept{name: "Early Roman Republic", contents: [ %Content{name: "Add a title"} ]},
                  %Concept{name: "First Punic War", contents: [ %Content{name: "Add a title"} ]},
                  %Concept{name: "Second Punic War", contents: [ %Content{name: "Add a title"} ]},
                  %Concept{name: "Third Punic War", contents: [ %Content{name: "Add a title"} ]},
                  %Concept{name: "Roman History", contents: [ %Content{name: "Add a title"} ]},
                  %Concept{name: "The Fall of Rome", contents: [ %Content{name: "Add a title"} ]}
                ]
              }
            ]
          }
        ]
      }
    ]
  })

Repo.insert!(%Institution{
  name: "Krista King Institute",
  location: "Chicago, IL",
  classrooms: [
      %Classroom{name: "Algebra Master",
                 prefix: "from zero to hero",
                 handle: "@algebraMaster",
        subjects: [
          %Subject{name: "Getting started", slug: "gs-#{Enum.random(11..999)}"},
          %Subject{name: "Operations", slug: "operations-#{Enum.random(11..999)}"},
          %Subject{name: "Rules of equations", slug: "roe-#{Enum.random(11..999)}"},
          %Subject{name: "Simple equations", slug: "simple-#{Enum.random(11..999)}",
            lessons: [
              %Lesson{name: "Begin",
                concepts: [
                  %Concept{name: "Introduction to simple equations", contents: [ %Content{name: "Add a title"} ]},
                  %Concept{name: "Simple equations with subscripts", contents: [ %Content{name: "Add a title"} ]},
                  %Concept{name: "Equations with parentheses", contents: [ %Content{name: "Add a title"} ]},
                  %Concept{name: "Word problems into equations", contents: [ %Content{name: "Add a title"} ]},
                  %Concept{name: "Consecutive integers", contents: [ %Content{name: "Add a title"} ]},
                  %Concept{name: "Bonus", contents: [ %Content{name: "Add a title"} ]}
                ]
              }
            ]
          }
        ]
      }
    ]
  })
