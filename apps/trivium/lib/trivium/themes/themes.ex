defmodule Trivium.Themes do

  alias Trivium.Repo
  alias Trivium.Classrooms.{Concept, Content} 
  alias Trivium.Multimedia.{Writing, Youtube, InternetImage}
  alias Trivium.Exercises.{Question, Quiz}

  def pt_egypt_predynastic(lesson_id) do
    Repo.insert!(%Concept{name: "Período pré-dinástico", lesson_id: lesson_id,
      contents: [
        %Content{name: "Intro", position: 1,
                 writings: [
                   %Writing{
                     body: "<div>
                      O período pré-dinástico ocorreu no Egito Antigo entre 3150 a 2686 aC.
                      Foi um período em que o Alto Egito e o Baixo Egito foram reunidos para ser um país em vez de dois.
                      Ao mesmo tempo, isso foi chamado de duas terras porque elas eram separadas.
                    </div>", position: 1}],
                  internet_images: [
                    %InternetImage{url: "https://d1j7twnp44fgl4.cloudfront.net/intro.jpg",
                              legend: "Ġgantija é um complexo de templos megalíticos do Neolítico na ilha mediterrânea de Gozo. Os templos Ġgantija são os primeiros dos templos megalíticos de Malta e são mais antigos do que as pirâmides do Egito"
                    },
                  ]
        },
        %Content{name: "Dinastias", position: 2,
                 writings: [
                   %Writing{
                     body: "<div>
                     Durante o período pré-dinástico, a Primeira Dinastia e a Segunda Dinastia governaram a terra.
                     Isso parou por volta do ano 2686 aC e foi quando o Antigo Reino começou.
                    </div>", position: 1}],
        },
        %Content{name: "Capital",position: 3,
                 writings: [
                   %Writing{
                     body: "<div>
                     A capital das Duas Terras era Memphis. Começou em Thinis e depois foi transferido para Memphis.
                    </div>", position: 1}],
                  internet_images: [
                    %InternetImage{url: "https://d1j7twnp44fgl4.cloudfront.net/Lost-City-of-Thinis_0.jpg",
                              legend: "A cidade perdida de Thinis, primeira capital de um Egito unido"},
                    %InternetImage{url: "https://d1j7twnp44fgl4.cloudfront.net/temple-of-ptah-at-memphis.jpg",
                              legend: "A antiga cidade de Memphis"},
                  ]
        },
        %Content{name: "Régua durante o período pré-dinástico", position: 4,
                 writings: [
                   %Writing{
                     body: "<div>
                     O governante do período pré-dinástico era um deus-rei egípcio, ou um faraó.
                     O primeiro rei das Duas Terras foi nomeado Menes. Mesmo que ele não tenha sido o primeiro rei real,
                     ele foi o primeiro sobre quem alguém escreveu e, portanto, ele é considerado o primeiro.
                     Algumas pessoas acreditam que Menes era o mesmo que Narmer, que foi quem fundou o Egito.
                     Embora Menes não pudesse ser Menes e Narmer, alguns acreditam que ele era.
                     Alguns acreditam que Narmer era uma figura importante para o Egito e é por isso que Menes é a mesma pessoa.
                    </div>", position: 1}],
                  internet_images: [
                    %InternetImage{url: "https://d1j7twnp44fgl4.cloudfront.net/narmer_palette_british_museum_plaster_cast.webp",
                              legend: "Cabeça de pedra calcária considerada Menes / Narmer, Museu Petrie de Arqueologia Egípcia",
                              position: 2}
                  ],
                  youtubes: [
                    %Youtube{url: "https://www.youtube.com/watch?v=iUO8y9xLFcE&t=4s",
                             legend: "Narmer Primeiro Faraó do Egito", position: 3}
                  ]
        },
        %Content{name: "Narmer Palette", position: 5,
                 writings: [
                   %Writing{
                     body: "<div>
                     A paleta Narmer é uma paleta usada para rituais.
                     Tinha a forma de uma coroa dupla que era do baixo Egito e do alto Egito.
                    </div>", position: 1}],
                  internet_images: [
                    %InternetImage{url: "https://d1j7twnp44fgl4.cloudfront.net/pharaoh_menes_sculpture_head_narmer_petrie_museum.webp",
                              legend: "Molde de gesso da paleta Narmer, Museu Britânico"}
                  ]
        },
        %Content{name: "Exercício 1", position: 6,
                 questions: [
                   %Question{question_text: "Qual é o período pré-dinástico?",
                             type: "question",
                             score: 10
                           }
                 ]
        },
        %Content{name: "Cultura", position: 7,
                 writings: [
                   %Writing{
                     body: "<div>
                     Os egípcios durante o período pré-dinástico eram agricultores e cultivavam e tinham animais. Durante esse período,
                     a agricultura desempenhou um papel importante, com o governo organizando um aumento em larga escala da
                     agricultura para suprir a população cada vez maior.
                     <br><br>
                     A evidência arqueológica nos diz que eles fizeram cerâmica e usaram cobre para torná-la mais forte.
                     Esses egípcios eram conhecidos por fazer tijolos e construir coisas. Eles usaram o sol para secar tijolos e foi assim
                     que eles foram capazes de construir edifícios.
                     <br><br>
                     Os egípcios eram muito talentosos, e desenvolveram ferramentas de pedra e fizeram arcos e paredes com formas diferentes
                     para que pudessem decorar os lugares onde moravam.
                    </div>", position: 1}],
                  internet_images: [
                    %InternetImage{url: "https://d1j7twnp44fgl4.cloudfront.net/predynastic_pots.jpg",
                              legend: "Cerâmica vermelha com tampa preta egípcia pré-dinástica"}
                  ]
        },
        %Content{name: "Baixo Egito e Alto Egito", position: 8,
                 writings: [
                   %Writing{
                     body: "<div>
                     Durante esse período, houve guerras entre os egípcios inferiores e superiores.
                     O Alto Egito fazia parte do rio Nilo e o Baixo Egito fazia parte do Delta do Nilo.
                     Quando o rei Menes (Narmer) estava no poder, ele lutou contra os inimigos que estavam no Delta.
                     Ele uniu os reinos Superior e Inferior.
                    </div>", position: 1}],
                  internet_images: [
                    %InternetImage{url: "https://d1j7twnp44fgl4.cloudfront.net/The-Nile_0.jpg",
                              legend: "O rio Nilo"}
                  ]
        },
        %Content{name: "Exercício 2", position: 9,
                 questions: [
                   %Question{question_text: "Quem foi o primeiro rei que foi registrado?",
                             type: "question",
                             score: 10
                           }
                 ]
        },
        %Content{name: "Símbolos", position: 10,
                 writings: [
                   %Writing{
                     body: "<div>
                     O Baixo Egito foi simbolizado pelo junco de papiro e o Alto Egito foi simbolizado pela flor de lótus.
                     Esses símbolos foram usados pelas regras após Menes e todas as regras que vieram no futuro.
                    </div>", position: 1}],
                  internet_images: [
                    %InternetImage{url: "https://d1j7twnp44fgl4.cloudfront.net/papyrus-1391754_1280.jpg",
                              legend: "Papyrus Egípcio Reed"}
                  ]
        },
        %Content{name: "Exercício 3", position: 11,
                 questions: [
                   %Question{question_text: "Qual era o outro nome que eles chamavam de Menes?",
                             type: "quizzes",
                             score: 12,
                             quizzes: [
                               %Quiz{quiz_text: "Hórus", correct_quiz: false},
                               %Quiz{quiz_text: "Narmer", correct_quiz: true},
                               %Quiz{quiz_text: "Memphis", correct_quiz: false}
                             ]
                           }
                 ]
        },
        %Content{name: "Mitologia", position: 12,
                 writings: [
                   %Writing{
                     body: "<div>
                     Na mitologia, o Alto Egito é simbolizado pelo deus Seth e o Baixo Egito é simbolizado pelo deus-falcão chamado Hórus.
                     Por causa desses símbolos, muitas pessoas começaram o boato de que os egípcios eram deuses e que todos eram poderosos.
                     Isso foi acreditado por milhares e milhares de anos.
                    </div>", position: 1}]
        },
        %Content{name: "Exercício 4", position: 13,
                 questions: [
                   %Question{question_text: "Quais foram algumas das coisas que os primeiros egípcios estavam começando a aprender?",
                             type: "quizzes",
                             score: 12,
                             quizzes: [
                               %Quiz{quiz_text: "Arte", correct_quiz: false},
                               %Quiz{quiz_text: "Escrita", correct_quiz: false},
                               %Quiz{quiz_text: "Arquitetura", correct_quiz: false},
                               %Quiz{quiz_text: "Todas são corretas", correct_quiz: true},
                             ]
                           }
                 ]
        },
        %Content{name: "Rituais da Morte", position: 14,
                 writings: [
                   %Writing{
                     body: "<div>
                     Pessoas ricas no período pré-dinástico teriam grandes funerais.
                     Eles construíam pirâmides nas quais os mortos foram enterrados e eram chamados mastabas.
                     Algumas tumbas reais foram construídas em Abydos e Saqqara. Além disso, durante esse período,
                     as pessoas sacrificariam humanos como parte de um ritual fúnebre.
                     Isso permitiu que os faraós tivessem servos quando voltassem após a morte.
                    </div>", position: 1}],
                  internet_images: [
                    %InternetImage{url: "https://d1j7twnp44fgl4.cloudfront.net/Opening_of_the_mouth_ceremony.jpg",
                              legend: "A cerimônia de abertura da boca sendo realizada em uma múmia antes do túmulo"}
                  ]
        },
        %Content{name: "Escrita", position: 15,
                 writings: [
                   %Writing{
                     body: "<div>
                     Durante esse período, a escrita egípcia foi baseada em símbolos.
                     Eles mostrariam itens diferentes que significariam palavras. Havia mais de 200 símbolos diferentes que eles usaram.
                    </div>", position: 1}],
                  internet_images: [
                    %InternetImage{url: "https://d1j7twnp44fgl4.cloudfront.net/333543567.jpg",
                              legend: "Hieróglifos esculpidos em uma placa de madeira"}
                  ]
        },
        %Content{name: "Exercício 5", position: 16,
                 questions: [
                   %Question{question_text: "A religião foi importante durante esse período?",
                             type: "question",
                             score: 10
                           }
                 ]
        },
        %Content{name: "Fatos sobre o período pré-dinástico", position: 17,
                 writings: [
                   %Writing{
                     body: "<div>
                       <ul>
                         <li>O período pré-dinástico foi semelhante ao período neolítico, que fazia parte da idade da pedra.</li>
                         <li>O povo do período pré-dinástico era mais avançado que os antigos egípcios.</li>
                         <li>Havia um calendário durante esse período que havia sido feito.</li>
                         <li>Os egípcios do período pré-dinástico haviam inventado medidas e astronomia básica.</li>
                         <li>A África influenciou a cultura do Baixo Egito.</li>
                         <li>As habilidades em escrita, arte e arquitetura foram ficando mais fortes durante esse período.</li>
                         <li>Os egípcios começam a se mudar para cidades maiores e querem morar em comunidades maiores.</li>
                         <li>Os nomes dos reis durante esse período foram gravados no Palermo Stone.</li>
                         <li>Durante esse período, as pessoas pagavam impostos.</li>
                         <li>A Paleta Narmer inclui diferentes tipos de escritos.</li>
                         <li>O governo ficou em templos feitos de madeira e arenitos.</li>
                         <li>Os deuses foram construídos a partir de estátuas e este era um lugar que as pessoas vinham e adoravam.</li>
                         <li>O período pré-dinástico era uma religião politeísta. Politeístas significa que eles adoraram muitos deuses ao mesmo tempo.</li>
                         <li>Alguns dos deuses tinham corpos humanos e cabeças de animais.</li>
                       </ul>
                     </div>", position: 1}]
        },
      ]
    })
  end

  def en_math(lesson_id) do
    Repo.insert!(%Concept{name: "Probability, Algebra and Numbers", lesson_id: lesson_id,
      contents: [
        %Content{name: "Let's start with the Promising Probability section :)",
          questions: [
            %Question{
              question_text: "A box contains 2 green balls and 5 yellow balls.
                              Two balls are drawn at random without replacement.
                              If the first ball drawn is green, what is the
                              probability the second ball is yellow?",
              type: "quizzes",
              score: 10,
              quizzes: [
                %Quiz{quiz_text: "4/7", correct_quiz: false},
                %Quiz{quiz_text: "5/6", correct_quiz: true},
                %Quiz{quiz_text: "2/3", correct_quiz: false},
                %Quiz{quiz_text: "5/7", correct_quiz: false},
              ]
            }
          ]
        },
        %Content{name: "More Probability",
          questions: [
            %Question{
              question_text: "Billy's drawer contains 5 blue socks and 6 black socks.
                              Billy pulls out two socks at random without replacement.
                              If the first sock drawn is black, what is the probability
                              the second sock is also black and Billy has a pair?",
              type: "quizzes",
              score: 12,
              quizzes: [
                %Quiz{quiz_text: "5/11", correct_quiz: false},
                %Quiz{quiz_text: "1/2", correct_quiz: true},
                %Quiz{quiz_text: "6/11", correct_quiz: false},
                %Quiz{quiz_text: "3/5", correct_quiz: false},
              ]
            }
          ]
        },
        %Content{name: "One more to go",
          questions: [
            %Question{
              question_text: "Now, Eva's bag contains 4 blue pens and 3 red pens.
                              Eva pulls out a pen at random, replaces it in the bag,
                              and then pulls out a second pen at random.
                              If the first pen is blue, what is the probability
                              the second pen is red?",
              type: "quizzes",
              score: 16,
              quizzes: [
                %Quiz{quiz_text: "3/7", correct_quiz: true},
                %Quiz{quiz_text: "1/2", correct_quiz: false},
                %Quiz{quiz_text: "4/7", correct_quiz: false},
                %Quiz{quiz_text: "2/3", correct_quiz: false},
              ]
            }
          ]
        },
      ]
    })
  end


end
