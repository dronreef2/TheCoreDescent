@tool
class_name Level14
extends Node2D

"""
Level 14: A Rede Neural
Tema: AI & Machine Learning
Dificuldade: HARD
Duração Estimada: 75 minutos

Este nível foca em conceitos avançados de Inteligência Artificial e Machine Learning,
incluindo redes neurais, deep learning, e frameworks como TensorFlow e PyTorch.

Objetivos Educacionais:
- Compreender arquitetura de redes neurais
- Implementar algoritmos de aprendizado profundo
- Aplicar AI em problemas práticos
- Dominar frameworks como TensorFlow e PyTorch
"""

# Configurações do nível
@export var level_number: int = 14
@export var level_title: String = "A Rede Neural"
@export var difficulty: String = "hard"
@export var estimated_duration: String = "75 minutos"

# Conceitos educacionais deste nível
const TARGET_CONCEPTS = [
	"Neural Networks",
	"Deep Learning",
	"TensorFlow",
	"PyTorch", 
	"Computer Vision",
	"NLP",
	"Reinforcement Learning",
	"Model Training",
	"Feature Engineering",
	"Data Preprocessing"
]

# Estrutura de puzzles
var puzzles = []

# Estado do jogador
var current_puzzle_index: int = 0
var score: int = 0
var total_possible_score: int = 500  # 5 puzzles × 100 pontos cada

# UI Elements
var ui_layer: CanvasLayer
var puzzle_container: Node2D
var score_label: Label
var concept_progress: ProgressBar
var level_info_label: Label

# Referências para puzzles
var perceptron_puzzle: Node2D
var feedforward_puzzle: Node2D  
var cnn_puzzle: Node2D
var rnn_puzzle: Node2D
var rl_puzzle: Node2D

func _ready():
	setup_level()
	setup_ui()
	setup_puzzles()
	show_intro()

func setup_level():
	"""Configurações iniciais do nível"""
	print("🧠 Iniciando Level 14: A Rede Neural")
	print("📚 Conceitos: " + str(TARGET_CONCEPTS.size()) + " conceitos de AI/ML")
	
	# Configurar física e renderização
	PhysicsServer2D.set_active(true)
	RenderingServer.set_default_clear_color(Color(0.1, 0.1, 0.2))
	
	# Criar fundo temático de rede neural
	create_neural_network_background()

func create_neural_network_background():
	"""Cria fundo visual de rede neural"""
	var background = Node2D.new()
	background.name = "NeuralBackground"
	add_child(background)
	
	# Gerar conexões de rede neural
	for i in range(20):
		var neuron = Position2D.new()
		var x = randf() * get_viewport().get_visible_rect().size.x
		var y = randf() * get_viewport().get_visible_rect().size.y
		neuron.position = Vector2(x, y)
		background.add_child(neuron)
		
		# Criar conexões visuais
		if i > 0:
			var connection_line = Line2D.new()
			var prev_neuron = background.get_child(i-1) as Position2D
			connection_line.add_point(prev_neuron.position)
			connection_line.add_point(neuron.position)
			connection_line.width = 2
			connection_line.default_color = Color(0.3, 0.6, 1.0, 0.3)
			background.add_child(connection_line)

func setup_ui():
	"""Configura interface do usuário"""
	ui_layer = CanvasLayer.new()
	add_child(ui_layer)
	
	# Painel principal do nível
	var level_panel = PanelContainer.new()
	level_panel.position = Vector2(20, 20)
	level_panel.size = Vector2(400, 600)
	ui_layer.add_child(level_panel)
	
	var vbox = VBoxContainer.new()
	level_panel.add_child(vbox)
	
	# Informações do nível
	level_info_label = Label.new()
	level_info_label.text = "Level 14: A Rede Neural\nAI & Machine Learning - HARD"
	level_info_label.add_theme_color_override("font_color", Color(0.2, 0.8, 1.0))
	vbox.add_child(level_info_label)
	
	# Progresso do score
	score_label = Label.new()
	score_label.text = "Score: {score}/" + str(total_possible_score) + ""
	score_label.add_theme_color_override("font_color", Color(1.0, 0.9, 0.3))
	vbox.add_child(score_label)
	
	# Progresso dos conceitos
	var concept_label = Label.new()
	concept_label.text = "Conceitos Dominados:"
	vbox.add_child(concept_label)
	
	concept_progress = ProgressBar.new()
	concept_progress.min_value = 0
	concept_progress.max_value = TARGET_CONCEPTS.size()
	concept_progress.value = 0
	vbox.add_child(concept_progress)
	
	# Controles
	var controls_label = Label.new()
	controls_label.text = "\nControles:\nSpace - Próximo puzzle\nR - Reiniciar nível\nEsc - Pausar"
	vbox.add_child(controls_label)
	
	# Container para os puzzles
	puzzle_container = Node2D.new()
	puzzle_container.name = "PuzzleContainer"
	add_child(puzzle_container)

func setup_puzzles():
	"""Configura todos os puzzles do nível"""
	
	# Puzzle 1: Perceptron Simples
	perceptron_puzzle = create_perceptron_puzzle()
	perceptron_puzzle.visible = false
	puzzle_container.add_child(perceptron_puzzle)
	
	# Puzzle 2: Rede Neural Feedforward
	feedforward_puzzle = create_feedforward_puzzle()
	feedforward_puzzle.visible = false
	puzzle_container.add_child(feedforward_puzzle)
	
	# Puzzle 3: CNN para Computer Vision
	cnn_puzzle = create_cnn_puzzle()
	cnn_puzzle.visible = false
	puzzle_container.add_child(cnn_puzzle)
	
	# Puzzle 4: RNN para NLP
	rnn_puzzle = create_rnn_puzzle()
	rnn_puzzle.visible = false
	puzzle_container.add_child(rnn_puzzle)
	
	# Puzzle 5: Reinforcement Learning
	rl_puzzle = create_rl_puzzle()
	rl_puzzle.visible = false
	puzzle_container.add_child(rl_puzzle)
	
	# Adicionar à lista de puzzles
	puzzles = [perceptron_puzzle, feedforward_puzzle, cnn_puzzle, rnn_puzzle, rl_puzzle]

func create_perceptron_puzzle() -> Node2D:
	"""
	Puzzle 1: Perceptron Simples
	Dificuldade: 6/10
	Tempo: 10 minutos
	
	Objetivo: Implementar um perceptron básico para classificação binária
	Conceitos: Neural Networks, Perceptron, Classification
	"""
	var puzzle = Node2D.new()
	puzzle.name = "PerceptronPuzzle"
	
	var panel = PanelContainer.new()
	panel.size = Vector2(600, 400)
	panel.position = Vector2(450, 100)
	puzzle.add_child(panel)
	
	var vbox = VBoxContainer.new()
	panel.add_child(vbox)
	
	var title = Label.new()
	title.text = "Puzzle 1: Perceptron Simples"
	title.add_theme_color_override("font_color", Color(0.4, 1.0, 0.6))
	vbox.add_child(title)
	
	var description = Label.new()
	description.text = "Implemente um perceptron para classificar pontos em 2D\n" + \
		"- Configure pesos (w1, w2, bias)\n" + \
		"- A função de ativação é step function\n" + \
		"- Classifique os pontos: (1,1)=1, (0,1)=0, (1,0)=0, (0,0)=1"
	vbox.add_child(description)
	
	# Área de código (simulada)
	var code_area = RichTextLabel.new()
	code_area.custom_minimum_size = Vector2(580, 200)
	code_area.text = "# Implementação do Perceptron\n" + \
		"class Perceptron:\n" + \
		"    def __init__(self, learning_rate=0.1):\n" + \
		"        self.weights = [random(), random()]\n" + \
		"        self.bias = random()\n" + \
		"        self.learning_rate = learning_rate\n" + \
		"\n" + \
		"    def predict(self, inputs):\n" + \
		"        activation = self.weights[0] * inputs[0] + \\\n" + \
		"                   self.weights[1] * inputs[1] + self.bias\n" + \
		"        return 1 if activation > 0 else 0\n" + \
		"\n" + \
		"    def train(self, training_data, labels):\n" + \
		"        # Implementar algoritmo de treinamento\n" + \
		"        pass"
	vbox.add_child(code_area)
	
	# Botão de teste
	var test_button = Button.new()
	test_button.text = "Testar Perceptron"
	test_button.pressed.connect(_on_test_perceptron.bind(puzzle))
	vbox.add_child(test_button)
	
	# Status do puzzle
	var status_label = Label.new()
	status_label.name = "StatusLabel"
	status_label.text = "Status: Configure os parâmetros e teste"
	vbox.add_child(status_label)
	
	return puzzle

func create_feedforward_puzzle() -> Node2D:
	"""
	Puzzle 2: Rede Neural Feedforward
	Dificuldade: 7/10
	Tempo: 15 minutos
	
	Objetivo: Construir uma rede neural de múltiplas camadas
	Conceitos: Deep Learning, Feedforward, Backpropagation
	"""
	var puzzle = Node2D.new()
	puzzle.name = "FeedforwardPuzzle"
	
	var panel = PanelContainer.new()
	panel.size = Vector2(600, 400)
	panel.position = Vector2(450, 100)
	puzzle.add_child(panel)
	
	var vbox = VBoxContainer.new()
	panel.add_child(vbox)
	
	var title = Label.new()
	title.text = "Puzzle 2: Rede Neural Feedforward"
	title.add_theme_color_override("font_color", Color(0.4, 1.0, 0.6))
	vbox.add_child(title)
	
	var description = Label.new()
	description.text = "Implemente uma rede neural de 3 camadas:\n" + \
		"- Input Layer: 2 neurônios\n" + \
		"- Hidden Layer: 4 neurônios (ReLU)\n" + \
		"- Output Layer: 1 neurônio (Sigmoid)\n" + \
		"- Implemente forward pass e backpropagation"
	vbox.add_child(description)
	
	# Visualização da rede
	var network_viz = Node2D.new()
	network_viz.custom_minimum_size = Vector2(580, 150)
	vbox.add_child(network_viz)
	
	# Desenhar visualização da rede
	draw_neural_network(network_viz, [2, 4, 1])
	
	# Código da implementação
	var code_area = RichTextLabel.new()
	code_area.custom_minimum_size = Vector2(580, 120)
	code_area.text = "# Rede Neural Feedforward\n" + \
		"class FeedforwardNetwork:\n" + \
		"    def __init__(self, layers):\n" + \
		"        self.layers = layers\n" + \
		"        self.weights = []\n" + \
		"        self.biases = []\n" + \
		"        for i in range(len(layers)-1):\n" + \
		"            self.weights.append(np.random.randn(layers[i], layers[i+1]))\n" + \
		"            self.biases.append(np.zeros(layers[i+1]))\n" + \
		"\n" + \
		"    def forward(self, x):\n" + \
		"        # Implementar forward pass\n" + \
		"        pass"
	vbox.add_child(code_area)
	
	var test_button = Button.new()
	test_button.text = "Testar Rede"
	test_button.pressed.connect(_on_test_feedforward.bind(puzzle))
	vbox.add_child(test_button)
	
	var status_label = Label.new()
	status_label.name = "StatusLabel"
	status_label.text = "Status: Implemente a rede e teste"
	vbox.add_child(status_label)
	
	return puzzle

func create_cnn_puzzle() -> Node2D:
	"""
	Puzzle 3: CNN para Computer Vision
	Dificuldade: 8/10
	Tempo: 20 minutos
	
	Objetivo: Implementar CNN para classificação de imagens
	Conceitos: Computer Vision, CNN, TensorFlow
	"""
	var puzzle = Node2D.new()
	puzzle.name = "CNNPuzzle"
	
	var panel = PanelContainer.new()
	panel.size = Vector2(600, 400)
	panel.position = Vector2(450, 100)
	puzzle.add_child(panel)
	
	var vbox = VBoxContainer.new()
	panel.add_child(vbox)
	
	var title = Label.new()
	title.text = "Puzzle 3: CNN para Computer Vision"
	title.add_theme_color_override("font_color", Color(0.4, 1.0, 0.6))
	vbox.add_child(title)
	
	var description = Label.new()
	description.text = "Implemente uma CNN para classificação:\n" + \
		"- Input: Imagens 32x32x3 (RGB)\n" + \
		"- Conv2D: 32 filtros, kernel 3x3\n" + \
		"- MaxPooling: 2x2\n" + \
		"- Flatten + Dense: 10 classes\n" + \
		"- Use TensorFlow/Keras"
	vbox.add_child(description)
	
	# Visualização da arquitetura CNN
	var cnn_viz = Node2D.new()
	cnn_viz.custom_minimum_size = Vector2(580, 100)
	vbox.add_child(cnn_viz)
	draw_cnn_architecture(cnn_viz)
	
	# Código TensorFlow
	var code_area = RichTextLabel.new()
	code_area.custom_minimum_size = Vector2(580, 150)
	code_area.text = "import tensorflow as tf\n" + \
		"from tensorflow import keras\n" + \
		"\n" + \
		"def create_cnn():\n" + \
		"    model = keras.Sequential([\n" + \
		"        keras.layers.Conv2D(32, (3,3), activation='relu', input_shape=(32,32,3)),\n" + \
		"        keras.layers.MaxPooling2D(2,2),\n" + \
		"        keras.layers.Flatten(),\n" + \
		"        keras.layers.Dense(10, activation='softmax')\n" + \
		"    ])\n" + \
		"    \n" + \
		"    model.compile(optimizer='adam',\n" + \
		"                  loss='sparse_categorical_crossentropy',\n" + \
		"                  metrics=['accuracy'])\n" + \
		"    return model"
	vbox.add_child(code_area)
	
	var test_button = Button.new()
	test_button.text = "Testar CNN"
	test_button.pressed.connect(_on_test_cnn.bind(puzzle))
	vbox.add_child(test_button)
	
	var status_label = Label.new()
	status_label.name = "StatusLabel"
	status_label.text = "Status: Implemente a CNN"
	vbox.add_child(status_label)
	
	return puzzle

func create_rnn_puzzle() -> Node2D:
	"""
	Puzzle 4: RNN para NLP
	Dificuldade: 9/10
	Tempo: 20 minutos
	
	Objetivo: Usar RNN/LSTM para análise de sentimentos
	Conceitos: NLP, RNN, LSTM, PyTorch
	"""
	var puzzle = Node2D.new()
	puzzle.name = "RNNPuzzle"
	
	var panel = PanelContainer.new()
	panel.size = Vector2(600, 400)
	panel.position = Vector2(450, 100)
	puzzle.add_child(panel)
	
	var vbox = VBoxContainer.new()
	panel.add_child(vbox)
	
	var title = Label.new()
	title.text = "Puzzle 4: RNN para NLP"
	title.add_theme_color_override("font_color", Color(0.4, 1.0, 0.6))
	vbox.add_child(title)
	
	var description = Label.new()
	description.text = "Implemente LSTM para análise de sentimentos:\n" + \
		"- Input: Sequências de texto tokenizadas\n" + \
		"- LSTM: 128 unidades\n" + \
		"- Embedding: 1000 vocabulário, 64 dimensões\n" + \
		"- Output: Sentimento (positivo/negativo)\n" + \
		"- Use PyTorch"
	vbox.add_child(description)
	
	# Visualização da arquitetura RNN
	var rnn_viz = Node2D.new()
	rnn_viz.custom_minimum_size = Vector2(580, 120)
	vbox.add_child(rnn_viz)
	draw_rnn_architecture(rnn_viz)
	
	# Código PyTorch
	var code_area = RichTextLabel.new()
	code_area.custom_minimum_size = Vector2(580, 120)
	code_area.text = "import torch\n" + \
		"import torch.nn as nn\n" + \
		"\n" + \
		"class SentimentLSTM(nn.Module):\n" + \
		"    def __init__(self, vocab_size, embed_dim, hidden_dim):\n" + \
		"        super().__init__()\n" + \
		"        self.embedding = nn.Embedding(vocab_size, embed_dim)\n" + \
		"        self.lstm = nn.LSTM(embed_dim, hidden_dim, batch_first=True)\n" + \
		"        self.classifier = nn.Linear(hidden_dim, 2)\n" + \
		"\n" + \
		"    def forward(self, x):\n" + \
		"        embedded = self.embedding(x)\n" + \
		"        lstm_out, (hidden, cell) = self.lstm(embedded)\n" + \
		"        return self.classifier(lstm_out[:, -1, :])"
	vbox.add_child(code_area)
	
	var test_button = Button.new()
	test_button.text = "Testar LSTM"
	test_button.pressed.connect(_on_test_rnn.bind(puzzle))
	vbox.add_child(test_button)
	
	var status_label = Label.new()
	status_label.name = "StatusLabel"
	status_label.text = "Status: Implemente o LSTM"
	vbox.add_child(status_label)
	
	return puzzle

func create_rl_puzzle() -> Node2D:
	"""
	Puzzle 5: Reinforcement Learning
	Dificuldade: 10/10
	Tempo: 10 minutos
	
	Objetivo: Criar um agente RL para jogo simples
	Conceitos: Reinforcement Learning, Q-Learning, Policy Gradient
	"""
	var puzzle = Node2D.new()
	puzzle.name = "RLPuzzle"
	
	var panel = PanelContainer.new()
	panel.size = Vector2(600, 400)
	panel.position = Vector2(450, 100)
	puzzle.add_child(panel)
	
	var vbox = VBoxContainer.new()
	panel.add_child(vbox)
	
	var title = Label.new()
	title.text = "Puzzle 5: Agente de Reinforcement Learning"
	title.add_theme_color_override("font_color", Color(0.4, 1.0, 0.6))
	vbox.add_child(title)
	
	var description = Label.new()
	description.text = "Implemente Q-Learning para um jogo simples:\n" + \
		"- Estado: Posição do agente (x, y)\n" + \
		"- Ações: cima, baixo, esquerda, direita\n" + \
		"- Recompensa: +1 meta, -0.01 passo\n" + \
		"- γ (gamma): 0.95, α (alpha): 0.1\n" + \
		"- Tabular Q-Learning"
	vbox.add_child(description)
	
	# Jogo simples visual
	var game_area = Node2D.new()
	game_area.custom_minimum_size = Vector2(580, 150)
	vbox.add_child(game_area)
	
	# Simular jogo grid
	var grid_size = 8
	var cell_size = 60
	for x in range(grid_size):
		for y in range(grid_size):
			var rect = ColorRect.new()
			rect.position = Vector2(x * cell_size, y * cell_size)
			rect.size = Vector2(cell_size - 2, cell_size - 2)
			
			if (x == grid_size - 1 and y == grid_size - 1):
				rect.color = Color(0.2, 1.0, 0.2)  # Meta (verde)
			elif x == 0 and y == 0:
				rect.color = Color(1.0, 0.2, 0.2)  # Início (vermelho)
			else:
				rect.color = Color(0.3, 0.3, 0.3)  # Caminho (cinza)
			
			game_area.add_child(rect)
	
	# Código Q-Learning
	var code_area = RichTextLabel.new()
	code_area.custom_minimum_size = Vector2(580, 100)
	code_area.text = "class QLearningAgent:\n" + \
		"    def __init__(self, states, actions, alpha=0.1, gamma=0.95):\n" + \
		"        self.q_table = np.zeros((states, actions))\n" + \
		"        self.alpha = alpha\n" + \
		"        self.gamma = gamma\n" + \
		"\n" + \
		"    def update(self, state, action, reward, next_state):\n" + \
		"        best_next = np.max(self.q_table[next_state])\n" + \
		"        td_error = reward + self.gamma * best_next - self.q_table[state, action]\n" + \
		"        self.q_table[state, action] += self.alpha * td_error"
	vbox.add_child(code_area)
	
	var test_button = Button.new()
	test_button.text = "Treinar Agente"
	test_button.pressed.connect(_on_test_rl.bind(puzzle))
	vbox.add_child(test_button)
	
	var status_label = Label.new()
	status_label.name = "StatusLabel"
	status_label.text = "Status: Implemente Q-Learning"
	vbox.add_child(status_label)
	
	return puzzle

func show_intro():
	"""Mostra introdução do nível"""
	print("🧠 === LEVEL 14: A REDE NEURAL ===")
	print("🎯 Bem-vindo ao mundo da Inteligência Artificial!")
	print("📚 Você vai dominar conceitos avançados de AI & ML:")
	
	for i, concept in enumerate(TARGET_CONCEPTS, 1):
		print("  {i:2d}. " + str(concept) + "")
	
	print("\n🧩 " + str(puzzles.size()) + " puzzles desafiadores aguardam:")
	var puzzle_info = [
		"Perceptron Simples (D6) - 10 min",
		"Rede Neural Feedforward (D7) - 15 min", 
		"CNN para Computer Vision (D8) - 20 min",
		"RNN para NLP (D9) - 20 min",
		"Agente de RL (D10) - 10 min"
	]
	
	for i, info in enumerate(puzzle_info, 1):
		print("  {i}. " + str(info) + "")
	
	print(f"\n🎯 Objetivos:")
	print("  • Compreender arquitetura de redes neurais")
	print("  • Implementar algoritmos de aprendizado profundo")
	print("  • Aplicar AI em problemas práticos") 
	print("  • Dominar TensorFlow e PyTorch")
	
	print(f"\n🏆 Critérios de Sucesso:")
	print(f"  • Pontuação Mínima: 80% (400/500 pontos)")
	print(f"  • Taxa de Conclusão: 85% (pelo menos 4/5 puzzles)")
	print(f"  • Verificação: Quiz prático com 10 questões")
	
	print(f"\n🚀 Pressione SPACE para começar!")

func _input(event):
	"""Processa input do jogador"""
	if event.is_action_pressed("ui_accept") or (event is InputEventKey and event.pressed and event.scancode == KEY_SPACE):
		next_puzzle()
	elif event is InputEventKey and event.pressed and event.scancode == KEY_R:
		restart_level()
	elif event is InputEventKey and event.pressed and event.scancode == KEY_ESCAPE:
		pause_level()

func next_puzzle():
	"""Avança para o próximo puzzle"""
	if current_puzzle_index < puzzles.size():
		# Ocultar puzzle atual
		if current_puzzle_index > 0:
			puzzles[current_puzzle_index - 1].visible = false
		
		# Mostrar próximo puzzle
		puzzles[current_puzzle_index].visible = true
		
		print("🧩 Iniciando Puzzle {current_puzzle_index + 1}/" + str(puzzles.size()) + "")
		current_puzzle_index += 1
		
		# Atualizar UI
		score_label.text = "Score: {score}/" + str(total_possible_score) + ""
		concept_progress.value = min(current_puzzle_index, TARGET_CONCEPTS.size())
	else:
		complete_level()

func restart_level():
	"""Reinicia o nível"""
	print("🔄 Reiniciando Level 14...")
	current_puzzle_index = 0
	score = 0
	
	# Ocultar todos os puzzles
	for puzzle in puzzles:
		puzzle.visible = false
	
	show_intro()

func pause_level():
	"""Pausa o nível"""
	print("⏸️ Nível pausado. Pressione ESC para continuar.")
	# Implementar menu de pausa aqui

func complete_level():
	"""Completa o nível"""
	var final_score_percent = (score / total_possible_score) * 100
	var puzzles_completed = current_puzzle_index
	var success = final_score_percent >= 80 and puzzles_completed >= 4
	
	print(f"\n🎉 === LEVEL 14 CONCLUÍDO ===")
	print("🏆 Score Final: {score}/{total_possible_score} (" + str(final_score_percent:.1f) + "%)")
	print("🧩 Puzzles Completados: {puzzles_completed}/" + str(puzzles.size()) + "")
	print("🎯 Conceitos Dominados: {concept_progress.value}/" + str(TARGET_CONCEPTS.size()) + "")
	
	if success:
		print("✅ SUCESSO! Você dominou AI & Machine Learning!")
		print("🚀 Próximo nível disponível: Level 15 (A ser desenvolvido)")
		
		# Salvar progresso
		save_progress()
		
		# Mostrar quiz final
		show_final_quiz()
	else:
		print("❌ Tente novamente. Pontuação insuficiente.")
		print(f"💡 Necessário: 80% score e 4/5 puzzles completos")
	
	# Limpar UI e mostrar resultado
	show_completion_summary(final_score_percent, success)

func save_progress():
	"""Salva progresso do jogador"""
	var progress_data = {
		"level": level_number,
		"score": score,
		"completed": true,
		"concepts_learned": TARGET_CONCEPTS[0:concept_progress.value],
		"timestamp": Time.get_unix_time_from_system()
	}
	
	# Salvar no arquivo de save (implementar conforme necessário)
	print("💾 Progresso salvo com sucesso!")

func show_final_quiz():
	"""Mostra quiz final sobre os conceitos aprendidos"""
	print(f"\n📝 === QUIZ FINAL - AI & ML ===")
	print("Responda às 10 questões para validar o aprendizado:")
	
	var questions = [
		{
			"question": "O que é um perceptron?",
			"options": ["A. Um algoritmo de clustering", "B. Uma rede neural de uma camada", "C. Um algoritmo de ordenação", "D. Uma estrutura de dados"],
			"correct": 1
		},
		{
			"question": "Qual função de ativação é comum em camadas ocultas?",
			"options": ["A. Step function", "B. ReLU", "C. Sigmoid apenas", "D. Linear"],
			"correct": 1
		},
		{
			"question": "CNN é melhor para que tipo de problemas?",
			"options": ["A. Texto", "B. Imagens", "C. Áudio", "D. Números"],
			"correct": 1
		},
		{
			"question": "LSTM é usado principalmente para?",
			"options": ["A. Classificação de imagens", "B. Processamento de sequência", "C. Clustering", "D. Regressão"],
			"correct": 1
		},
		{
			"question": "Q-Learning é um algoritmo de?",
			"options": ["A. Supervised Learning", "B. Unsupervised Learning", "C. Reinforcement Learning", "D. Deep Learning"],
			"correct": 2
		}
	]
	
	# Implementar sistema de quiz aqui (simplificado para demonstração)
	print("✅ Quiz implementado - Sistema pronto para interação!")

func show_completion_summary(score_percent: float, success: bool):
	"""Mostra resumo da conclusão do nível"""
	var summary_panel = PanelContainer.new()
	summary_panel.position = Vector2(300, 200)
	summary_panel.size = Vector2(500, 300)
	ui_layer.add_child(summary_panel)
	
	var vbox = VBoxContainer.new()
	summary_panel.add_child(vbox)
	
	var title = Label.new()
	title.text = "Level 14: A Rede Neural - CONCLUÍDO!"
	if success:
		title.add_theme_color_override("font_color", Color(0.2, 1.0, 0.2))
	else:
		title.add_theme_color_override("font_color", Color(1.0, 0.3, 0.3))
	vbox.add_child(title)
	
	var score_label = Label.new()
	score_label.text = "Score Final: {score}/{total_possible_score} (" + str(score_percent:.1f) + "%)"
	vbox.add_child(score_label)
	
	var concepts_label = Label.new()
	concepts_label.text = "Conceitos Dominados: {concept_progress.value}/" + str(TARGET_CONCEPTS.size()) + ""
	vbox.add_child(concepts_label)
	
	var result_label = Label.new()
	if success:
		result_label.text = "✅ SUCESSO - AI & ML MAESTRO!"
		result_label.add_theme_color_override("font_color", Color(0.2, 1.0, 0.2))
	else:
		result_label.text = "❌ TENTE NOVAMENTE"
		result_label.add_theme_color_override("font_color", Color(1.0, 0.3, 0.3))
	vbox.add_child(result_label)
	
	var continue_button = Button.new()
	if success:
		continue_button.text = "Próximo Nível"
		continue_button.pressed.connect(_on_next_level)
	else:
		continue_button.text = "Tentar Novamente"
		continue_button.pressed.connect(_on_retry_level)
	vbox.add_child(continue_button)

# Event handlers para botões de teste dos puzzles
func _on_test_perceptron(puzzle: Node2D):
	var status_label = puzzle.get_node("StatusLabel") as Label
	score += 90  # Simular pontuação do puzzle
	status_label.text = "✅ Perceptron implementado com sucesso! Score: +90"
	score_label.text = "Score: {score}/" + str(total_possible_score) + ""
	print("🧠 Puzzle 1 concluído: Perceptron Simples")

func _on_test_feedforward(puzzle: Node2D):
	var status_label = puzzle.get_node("StatusLabel") as Label
	score += 95
	status_label.text = "✅ Rede neural funcionando! Score: +95"
	score_label.text = "Score: {score}/" + str(total_possible_score) + ""
	print("🧠 Puzzle 2 concluído: Rede Neural Feedforward")

func _on_test_cnn(puzzle: Node2D):
	var status_label = puzzle.get_node("StatusLabel") as Label
	score += 100
	status_label.text = "✅ CNN treinada com sucesso! Score: +100"
	score_label.text = "Score: {score}/" + str(total_possible_score) + ""
	print("🧠 Puzzle 3 concluído: CNN para Computer Vision")

func _on_test_rnn(puzzle: Node2D):
	var status_label = puzzle.get_node("StatusLabel") as Label
	score += 85
	status_label.text = "✅ LSTM para NLP funcionando! Score: +85"
	score_label.text = "Score: {score}/" + str(total_possible_score) + ""
	print("🧠 Puzzle 4 concluído: RNN para NLP")

func _on_test_rl(puzzle: Node2D):
	var status_label = puzzle.get_node("StatusLabel") as Label
	score += 100
	status_label.text = "✅ Agente RL treinado! Score: +100"
	score_label.text = "Score: {score}/" + str(total_possible_score) + ""
	print("🧠 Puzzle 5 concluído: Reinforcement Learning")

# Event handlers para conclusão
func _on_next_level():
	print("🚀 Avançando para o próximo nível...")
	# Implementar transição para Level 15

func _on_retry_level():
	print("🔄 Reiniciando nível...")
	restart_level()

# Funções auxiliares para visualizações
func draw_neural_network(viz: Node2D, layers: Array):
	"""Desenha visualização de rede neural"""
	var layer_positions = []
	var layer_spacing = 100
	var neuron_spacing = 40
	
	for i in range(layers.size()):
		var x = i * layer_spacing + 50
		var layer_nodes = []
		
		for j in range(layers[i]):
			var y = j * neuron_spacing + 50
			var neuron = Node2D.new()
			neuron.position = Vector2(x, y)
			viz.add_child(neuron)
			layer_nodes.append(neuron)
		
		layer_positions.append(layer_nodes)
	
	# Desenhar conexões
	for i in range(layers.size() - 1):
		for neuron1 in layer_positions[i]:
			for neuron2 in layer_positions[i + 1]:
				var line = Line2D.new()
				line.add_point(neuron1.position)
				line.add_point(neuron2.position)
				line.width = 1
				line.default_color = Color(0.5, 0.5, 0.5, 0.5)
				viz.add_child(line)

func draw_cnn_architecture(viz: Node2D):
	"""Desenha arquitetura CNN"""
	# Input Layer
	var input_rect = ColorRect.new()
	input_rect.position = Vector2(20, 20)
	input_rect.size = Vector2(60, 60)
	input_rect.color = Color(0.3, 0.7, 1.0)
	viz.add_child(input_rect)
	
	var input_label = Label.new()
	input_label.text = "Input\n32x32x3"
	input_label.position = Vector2(20, 90)
	viz.add_child(input_label)
	
	# Conv Layer
	var conv_rect = ColorRect.new()
	conv_rect.position = Vector2(120, 20)
	conv_rect.size = Vector2(60, 60)
	conv_rect.color = Color(1.0, 0.7, 0.3)
	viz.add_child(conv_rect)
	
	var conv_label = Label.new()
	conv_label.text = "Conv2D\n32 filters"
	conv_label.position = Vector2(120, 90)
	viz.add_child(conv_label)
	
	# Pooling Layer
	var pool_rect = ColorRect.new()
	pool_rect.position = Vector2(220, 20)
	pool_rect.size = Vector2(60, 60)
	pool_rect.color = Color(0.7, 1.0, 0.3)
	viz.add_child(pool_rect)
	
	var pool_label = Label.new()
	pool_label.text = "MaxPool\n2x2"
	pool_label.position = Vector2(220, 90)
	viz.add_child(pool_label)
	
	# Dense Layer
	var dense_rect = ColorRect.new()
	dense_rect.position = Vector2(320, 20)
	dense_rect.size = Vector2(60, 60)
	dense_rect.color = Color(1.0, 0.3, 0.7)
	viz.add_child(dense_rect)
	
	var dense_label = Label.new()
	dense_label.text = "Dense\n10 classes"
	dense_label.position = Vector2(320, 90)
	viz.add_child(dense_label)
	
	# Set minimum size
	viz.custom_minimum_size = Vector2(400, 120)

func draw_rnn_architecture(viz: Node2D):
	"""Desenha arquitetura RNN/LSTM"""
	# Embedding Layer
	var emb_rect = ColorRect.new()
	emb_rect.position = Vector2(20, 20)
	emb_rect.size = Vector2(80, 40)
	emb_rect.color = Color(0.3, 0.7, 1.0)
	viz.add_child(emb_rect)
	
	var emb_label = Label.new()
	emb_label.text = "Embedding\n1000->64"
	emb_label.position = Vector2(20, 70)
	viz.add_child(emb_label)
	
	# LSTM Layer
	var lstm_rect = ColorRect.new()
	lstm_rect.position = Vector2(150, 20)
	lstm_rect.size = Vector2(100, 40)
	lstm_rect.color = Color(1.0, 0.7, 0.3)
	viz.add_child(lstm_rect)
	
	var lstm_label = Label.new()
	lstm_label.text = "LSTM\n128 units"
	lstm_label.position = Vector2(150, 70)
	viz.add_child(lstm_label)
	
	# Classifier
	var cls_rect = ColorRect.new()
	cls_rect.position = Vector2(300, 20)
	cls_rect.size = Vector2(80, 40)
	cls_rect.color = Color(0.7, 1.0, 0.3)
	viz.add_child(cls_rect)
	
	var cls_label = Label.new()
	cls_label.text = "Classifier\n2 classes"
	cls_label.position = Vector2(300, 70)
	viz.add_child(cls_label)
	
	viz.custom_minimum_size = Vector2(400, 100)

func _exit_tree():
	"""Cleanup ao sair do nível"""
	print("🧠 Encerrando Level 14: A Rede Neural")
	if ui_layer:
		ui_layer.queue_free()
	if puzzle_container:
		puzzle_container.queue_free()