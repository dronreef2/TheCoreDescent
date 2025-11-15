# THE CORE DESCENT - NÍVEL 8: A CIÊNCIA DOS DADOS
# Arquivo: Level8.gd - Data Science e Machine Learning

extends Node2D
class_name Level8

# Configurações do nível
@export var level_name: String = "A Ciência dos Dados"
@export var level_description: String = "Explore, analise e extraia insights de grandes volumes de dados"
@export var target_moves: int = 36  # Número ideal de movimentos
@export var grid_width: int = 34
@export var grid_height: int = 28

# Referências aos sistemas
var game_manager: Node
var drag_system: DragAndDropSystem
var player: PlayerController
var ui_manager: Node
var ability_system: Node

# Estado do nível
enum LevelState { LOADING, PLAYING, COMPLETED, FAILED }
var current_state: LevelState = LevelState.LOADING

# Dados do nível
var start_position: Vector2i = Vector2i(2, 14)
var goal_position: Vector2i = Vector2i(31, 14)
var start_block: LogicBlock
var goal_block: LogicBlock

# Objetivo atual
var moves_used: int = 0
var blocks_placed: int = 0
var _object_pool_size: int = 10
var _resource_pool: Array = []
var level_timer: float = 0.0
var is_timer_running: bool = false
var ability_used_count: Dictionary = {}
var data_processing_pipeline: Array = []
var ml_models: Array = []
var statistical_analysis: Dictionary = {}
var big_data_components: Array = []
var visualization_dashboards: Array = []
var model_performance: Dictionary = {}
var data_quality_metrics: Dictionary = {}
var feature_engineering: Array = []
var algorithm_optimization: Dictionary = {}

# Puzzles disponíveis
var available_puzzles: Array[Dictionary] = []
var current_puzzle_index: int = 0

# UI Elements
var move_counter: Label
var timer_label: Label
var puzzle_info_label: Label
var progress_bar: ProgressBar
var data_viz_panel: Control
var model_metrics_panel: Control

# Sinais
signal level_completed
signal level_failed
signal puzzle_solved(puzzle_data: Dictionary)
signal move_made
signal ability_activated
signal data_processed(dataset: Dictionary)
signal model_trained(model_data: Dictionary)

# Puzzles do nível - Foco em Data Science
func initialize_puzzles():
    available_puzzles = [
        {
            "id": "data_exploration_analysis",
            "title": "Análise Exploratória de Dados",
            "description": "Explore e entenda a estrutura dos dados com técnicas estatísticas",
            "target_moves": 12,
            "start_position": Vector2i(2, 10),
            "goal_position": Vector2i(14, 20),
            "blocks_required": 7,
            "concepts": ["EDA", "Pandas", "NumPy", "Statistical Analysis", "Data Visualization", "Missing Data", "Outlier Detection"],
            "mechanics": {
                "data_profiling": true,
                "statistical_summary": true,
                "correlation_analysis": true,
                "visualization_generation": true
            },
            "obstacles": [
                {"type": "missing_data", "position": Vector2i(6, 12), "missing_percentage": 15.2},
                {"type": "data_type_inconsistency", "position": Vector2i(9, 16), "columns": ["age", "income", "timestamp"]},
                {"type": "outliers", "position": Vector2i(12, 14), "detection_method": "IQR", "threshold": 3.0}
            ],
            "datasets": [
                {"name": "customer_data.csv", "size": "2.5GB", "rows": 5000000, "columns": 47},
                {"name": "sales_transactions.json", "size": "800MB", "records": 1200000},
                {"name": "user_behavior.parquet", "size": "1.2GB", "partitions": 10}
            ]
        },
        {
            "id": "machine_learning_pipeline",
            "title": "Pipeline de Machine Learning",
            "description": "Construa um pipeline completo de ML com validação cruzada",
            "target_moves": 15,
            "start_position": Vector2i(4, 24),
            "goal_position": Vector2i(18, 6),
            "blocks_required": 9,
            "concepts": ["Scikit-learn", "Feature Engineering", "Cross Validation", "Model Training", "Hyperparameter Tuning", "Pipeline", "Grid Search"],
            "mechanics": {
                "feature_selection": true,
                "model_training": true,
                "cross_validation": true,
                "hyperparameter_optimization": true
            },
            "obstacles": [
                {"type": "imbalanced_dataset", "position": Vector2i(8, 20), "ratio": "1:99"},
                {"type": "overfitting_risk", "position": Vector2i(11, 16), "validation_score": 0.95},
                {"type": "feature_curse", "position": Vector2i(14, 12), "features": 1000, "samples": 500}
            ],
            "algorithms": ["Random Forest", "XGBoost", "SVM", "Neural Networks", "Logistic Regression"]
        },
        {
            "id": "deep_learning_neural",
            "title": "Deep Learning e Redes Neurais",
            "description": "Implemente redes neurais profundas com TensorFlow/PyTorch",
            "target_moves": 18,
            "start_position": Vector2i(16, 4),
            "goal_position": Vector2i(28, 22),
            "blocks_required": 11,
            "concepts": ["TensorFlow", "PyTorch", "CNN", "RNN", "LSTM", "Transfer Learning", "GPU Acceleration", "Model Architecture"],
            "mechanics": {
                "neural_architecture": true,
                "backpropagation": true,
                "gradient_descent": true,
                "model_regularization": true
            },
            "obstacles": [
                {"type": "vanishing_gradients", "position": Vector2i(20, 8), "depth": 12},
                {"type": "gpu_memory", "position": Vector2i(23, 14), "required_vram": "8GB"},
                {"type": "training_time", "position": Vector2i(26, 18), "estimated_hours": 72}
            ],
            "architectures": ["CNN", "RNN", "LSTM", "Transformer", "GAN", "Autoencoder"]
        },
        {
            "id": "big_data_processing",
            "title": "Processamento de Big Data",
            "description": "Processe grandes volumes de dados com Spark e MapReduce",
            "target_moves": 20,
            "start_position": Vector2i(6, 28),
            "goal_position": Vector2i(22, 2),
            "blocks_required": 12,
            "concepts": ["Apache Spark", "MapReduce", "Hadoop", "Distributed Computing", "Data Partitioning", "Fault Tolerance", "Spark SQL"],
            "mechanics": {
                "distributed_processing": true,
                "data_partitioning": true,
                "fault_tolerance": true,
                "performance_optimization": true
            },
            "obstacles": [
                {"type": "data_skew", "position": Vector2i(10, 26), "skew_factor": 8.5},
                {"type": "network_bottleneck", "position": Vector2i(14, 18), "bandwidth": "1Gbps"},
                {"type": "memory_pressure", "position": Vector2i(18, 10), "cluster_memory": "512GB"}
            ],
            "frameworks": ["Spark", "Hadoop", "Kafka", "Flink", "Storm"]
        },
        {
            "id": "advanced_analytics_algorithms",
            "title": "Algoritmos Avançados de Analytics",
            "description": "Implemente algoritmos avançados de clustering, recommender systems e NLP",
            "target_moves": 22,
            "start_position": Vector2i(24, 8),
            "goal_position": Vector2i(32, 24),
            "blocks_required": 13,
            "concepts": ["K-Means", "DBSCAN", "Collaborative Filtering", "NLP", "Text Mining", "Sentiment Analysis", "Topic Modeling"],
            "mechanics": {
                "clustering_algorithms": true,
                "recommendation_systems": true,
                "nlp_processing": true,
                "text_analysis": true
            },
            "obstacles": [
                {"type": "dimensionality_curse", "position": Vector2i(27, 12), "dimensions": 1000},
                {"type": "sparse_matrix", "position": Vector2i(29, 16), "sparsity": 0.998},
                {"type": "language_complexity", "position": Vector2i(31, 20), "languages": ["EN", "PT", "ES", "FR"]}
            ],
            "algorithms": ["K-Means", "Hierarchical", "DBSCAN", "LDA", "Word2Vec", "BERT"]
        },
        {
            "id": "model_deployment_production",
            "title": "Deploy e Produção de Modelos",
            "description": "Implante modelos em produção com monitoring e A/B testing",
            "target_moves": 25,
            "start_position": Vector2i(10, 4),
            "goal_position": Vector2i(30, 26),
            "blocks_required": 15,
            "concepts": ["MLOps", "Model Deployment", "A/B Testing", "Model Monitoring", "Model Drift", "Containerization", "API Serving"],
            "mechanics": {
                "model_serving": true,
                "performance_monitoring": true,
                "drift_detection": true,
                "model_versioning": true
            },
            "obstacles": [
                {"type": "model_drift", "position": Vector2i(15, 8), "drift_threshold": 0.15},
                {"type": "latency_requirements", "position": Vector2i(20, 18), "max_latency": "100ms"},
                {"type": "scalability", "position": Vector2i(25, 22), "req_qps": 10000}
            ],
            "platforms": ["AWS SageMaker", "Google AI Platform", "Azure ML", "Docker", "Kubernetes"]
        }
    ]

func _ready():
    _initialize_concept_cache()
    _initialize_object_pool()
    print("Level 8: A Ciência dos Dados - Iniciando...")
    
    # Inicializar puzzles
    initialize_puzzles()
    
    # Configurar timer
    level_timer = 0.0
    is_timer_running = true
    
    # Configurar estado inicial
    current_state = LevelState.LOADING
    
    # Configurar blocos do tabuleiro
    setup_grid()
    setup_blocks()
    
    # Conectar sinais
    setup_signals()
    
    # Inicializar UI
    setup_ui()
    
    # Marcar como pronto para iniciar
    current_state = LevelState.PLAYING
    print("Level 8 pronto para jogar!")

func setup_grid():
    """Configura a grade do tabuleiro data science"""
    # Criar blocos de início e fim
    start_block = create_logic_block(start_position, "start", "Início da Análise de Dados")
    goal_block = create_logic_block(goal_position, "goal", "Insights e Predições")
    
    # Adicionar obstáculos baseados no puzzle atual
    var current_puzzle = available_puzzles[current_puzzle_index]
    setup_puzzle_obstacles(current_puzzle.get("obstacles", []))

func setup_blocks():
    """Configura os blocos lógicos no tabuleiro data science"""
    var current_puzzle = available_puzzles[current_puzzle_index]
    var concepts = current_puzzle.get("concepts", [])
    
    # Adicionar blocos para cada conceito
    for concept in concepts:
        var position = get_random_valid_position()
        create_logic_block(position, "concept", concept)
    
    # Adicionar blocos específicos de dados
    add_data_specific_blocks()

func create_logic_block(position: Vector2i, block_type: String, data: String) -> LogicBlock:
    """Cria um bloco lógico na posição especificada"""
    var block = LogicBlock.new()
    block.position = position
    block.block_type = block_type
    block.data = data
    block.set("custom_data", {
        "level": 8,
        "concept": data,
        "data_context": true,
        "complexity": get_data_complexity(data),
        "performance_requirements": get_performance_requirements(data)
    })
    
    add_child(block)
    return block

func add_data_specific_blocks():
    """Adiciona blocos específicos de data science"""
    var data_types = ["Structured Data", "Unstructured Data", "Time Series", "Text Data", "Image Data"]
    var ml_categories = ["Supervised", "Unsupervised", "Reinforcement"]
    
    for data_type in data_types:
        var position = get_random_valid_position()
        create_logic_block(position, "data_type", data_type)
    
    for category in ml_categories:
        var position = get_random_valid_position()
        create_logic_block(position, "ml_category", category)

func setup_puzzle_obstacles(obstacles: Array):
    """Configura obstáculos específicos do puzzle data science"""
    for obstacle in obstacles:
        var obstacle_node = create_data_science_obstacle(obstacle)
        add_child(obstacle_node)

func create_data_science_obstacle(obstacle_data: Dictionary) -> Node:
    """Cria um obstáculo específico de data science"""
    var obstacle_type = obstacle_data.get("type", "generic")
    var position = obstacle_data.get("position", Vector2i(0, 0))
    var obstacle = Node2D.new()
    obstacle.position = position * 32
    
    # Configurar propriedades específicas de data science
    obstacle.set("obstacle_type", obstacle_type)
    obstacle.set("obstacle_data", obstacle_data)
    obstacle.set("data_complexity", calculate_data_complexity(obstacle_data))
    obstacle.set("processing_difficulty", get_processing_difficulty(obstacle_type))
    
    return obstacle

func get_data_complexity(data: String) -> String:
    """Retorna a complexidade dos dados"""
    var complexity_map = {
        "Big Data": "high",
        "Time Series": "medium",
        "Text Data": "medium",
        "Image Data": "high",
        "Structured Data": "low",
        "Unstructured Data": "high"
    }
    return complexity_map.get(data, "medium")

func get_performance_requirements(data: String) -> Dictionary:
    """Retorna requisitos de performance para o dado"""
    var requirements = {
        "memory_gb": 8,
        "cpu_cores": 4,
        "gpu_required": false,
        "estimated_time_hours": 2
    }
    
    # Ajustar baseado no tipo de dados
    if "deep" in data.to_lower() or "neural" in data.to_lower():
        requirements.gpu_required = true
        requirements.memory_gb = 16
        requirements.cpu_cores = 8
        requirements.estimated_time_hours = 24
    
    return requirements

func calculate_data_complexity(obstacle_data: Dictionary) -> float:
    """Calcula a complexidade dos dados baseada no obstáculo"""
    var base_complexity = 1.0
    
    match obstacle_data.get("type", ""):
        "missing_data":
            base_complexity += obstacle_data.get("missing_percentage", 10) / 100.0
        "imbalanced_dataset":
            base_complexity += float(obstacle_data.get("ratio", "1:10").split(":")[1].to_int()) / 100.0
        "dimensionality_curse":
            base_complexity += obstacle_data.get("dimensions", 100) / 1000.0
        "data_skew":
            base_complexity += obstacle_data.get("skew_factor", 1.0) / 10.0
    
    return min(base_complexity, 5.0)

func get_processing_difficulty(obstacle_type: String) -> String:
    """Retorna a dificuldade de processamento"""
    var difficulty_map = {
        "missing_data": "medium",
        "imbalanced_dataset": "high",
        "overfitting_risk": "high",
        "dimensionality_curse": "very_high",
        "gpu_memory": "high",
        "model_drift": "medium",
        "scalability": "very_high"
    }
    return difficulty_map.get(obstacle_type, "medium")

func setup_signals():
    """Configura as conexões de sinais"""
    if drag_system:
        drag_system.block_dropped.connect(_on_block_dropped)
    
    if player:
        player.move_completed.connect(_on_player_move_completed)
    
    if game_manager:
        game_manager.pause_requested.connect(_on_pause_requested)

func setup_ui():
    """Configura a interface do usuário data science"""
    move_counter = Label.new()
    timer_label = Label.new()
    puzzle_info_label = Label.new()
    progress_bar = ProgressBar.new()
    data_viz_panel = Control.new()
    model_metrics_panel = Control.new()

func _process(delta: float):
    """Atualiza o estado do nível data science"""
    if is_timer_running and current_state == LevelState.PLAYING:
        level_timer += delta
        update_timer_display()
    
    # Verificar condições específicas de data science
    check_data_quality()
    check_model_performance()
    check_computational_limits()
    
    # Verificar condições de vitória/derrota
    check_level_completion()
    check_level_failure()

func check_data_quality():
    """Verifica qualidade dos dados"""
    var current_puzzle = available_puzzles[current_puzzle_index]
    var obstacles = current_puzzle.get("obstacles", [])
    
    for obstacle in obstacles:
        var obstacle_type = obstacle.get("type", "")
        
        match obstacle_type:
            "missing_data":
                var missing_pct = obstacle.get("missing_percentage", 0)
                if missing_pct > 20:
                    print("Aviso: %d%% de dados faltantes detectado" % missing_pct)
            "outliers":
                print("Outliers detectados - investigar distribuição")
            "data_type_inconsistency":
                print("Inconsistências de tipo de dados detectadas")

func check_model_performance():
    """Verifica performance dos modelos"""
    var current_puzzle = available_puzzles[current_puzzle_index]
    var puzzle_id = current_puzzle.get("id", "")
    
    if "machine_learning" in puzzle_id or "deep_learning" in puzzle_id:
        # Simular métricas de performance
        var accuracy = calculate_simulated_accuracy()
        var precision = calculate_simulated_precision()
        var recall = calculate_simulated_recall()
        
        if accuracy < 0.7:
            print("Aviso: Accuracy baixa (%d%%) - considerar feature engineering" % int(accuracy * 100))

func check_computational_limits():
    """Verifica limites computacionais"""
    var memory_usage = estimate_memory_usage()
    var cpu_usage = estimate_cpu_usage()
    
    if memory_usage > 32:  # GB
        print("Aviso: Alto uso de memória (%dGB) - otimizar algoritmos" % memory_usage)
    
    if cpu_usage > 80:  # %
        print("Aviso: Alto uso de CPU (%d%%) - considerar paralelização" % cpu_usage)

func calculate_simulated_accuracy() -> float:
    """Calcula accuracy simulada baseada no progresso"""
    var base_accuracy = 0.65
    var improvement_factor = float(moves_used) / float(target_moves)
    return min(base_accuracy + (improvement_factor * 0.25), 0.95)

func calculate_simulated_precision() -> float:
    """Calcula precision simulada"""
    return calculate_simulated_accuracy() * 0.9

func calculate_simulated_recall() -> float:
    """Calcula recall simulado"""
    return calculate_simulated_accuracy() * 0.85

func estimate_memory_usage() -> int:
    """Estima uso de memória em GB"""
    var base_usage = 4
    var puzzle_complexity = current_puzzle_index + 1
    return base_usage + (puzzle_complexity * 2)

func estimate_cpu_usage() -> int:
    """Estima uso de CPU em %"""
    var base_usage = 20
    var moves_factor = moves_used * 2
    return min(base_usage + moves_factor, 100)

func update_timer_display():
    """Atualiza a exibição do timer com contexto data science"""
    var minutes = int(level_timer / 60)
    var seconds = int(level_timer % 60)
    var complexity = get_current_complexity_level()
    
    if timer_label:
        timer_label.text = "Tempo: %02d:%02d | Complexidade: %s | Dados: %dGB" % [
            minutes, seconds, complexity, get_estimated_data_size()
        ]

func get_current_complexity_level() -> String:
    """Retorna o nível de complexidade atual"""
    var complexity_levels = ["Baixa", "Média", "Alta", "Muito Alta", "Extrema", "Máxima"]
    var index = min(current_puzzle_index, complexity_levels.size() - 1)
    return complexity_levels[index]

func get_estimated_data_size() -> int:
    """Retorna o tamanho estimado dos dados em GB"""
    var size_map = [2, 5, 12, 25, 50, 100]  # GB por puzzle
    return size_map[min(current_puzzle_index, size_map.size() - 1)]

func check_level_completion():
    """Verifica se o nível foi completado"""
    if current_puzzle_index >= available_puzzles.size():
        current_state = LevelState.COMPLETED
        is_timer_running = false
        emit_signal("level_completed")
        print("Level 8 concluído! Pipeline de Data Science completo!")
        return
    
    var current_puzzle = available_puzzles[current_puzzle_index]
    if is_puzzle_solved(current_puzzle):
        current_puzzle_index += 1
        if current_puzzle_index < available_puzzles.size():
            load_next_puzzle()
        emit_signal("puzzle_solved", current_puzzle)

func is_puzzle_solved(puzzle: Dictionary) -> bool:
    """Verifica se um puzzle data science foi resolvido"""
    var mechanics = puzzle.get("mechanics", {})
    var data_requirements = puzzle.get("datasets", [])
    var algorithm_requirements = puzzle.get("algorithms", [])
    
    var implemented_count = 0
    var required_count = mechanics.size()
    
    # Verificar mechanics implementados
    for mechanic in mechanics.keys():
        if mechanics[mechanic] == true:
            implemented_count += 1
    
    # Verificar qualidade dos dados
    var data_quality_met = check_data_quality_requirements(puzzle)
    
    # Verificar performance dos algoritmos
    var performance_met = check_algorithm_performance(puzzle)
    
    return (implemented_count >= required_count * 0.8) and data_quality_met and performance_met

func check_data_quality_requirements(puzzle: Dictionary) -> bool:
    """Verifica se os requisitos de qualidade de dados foram atendidos"""
    var obstacles = puzzle.get("obstacles", [])
    
    for obstacle in obstacles:
        var obstacle_type = obstacle.get("type", "")
        
        match obstacle_type:
            "missing_data":
                # Deve ser resolvido com técnicas de imputação
                return moves_used > 15  # Indicativo de tratamento de dados
            "outliers":
                # Deve ser tratado com métodos estatísticos
                return true  # Simplificado
            "data_type_inconsistency":
                # Deve ser corrigido
                return true  # Simplificado
            _:
                return true
    
    return true

func check_algorithm_performance(puzzle: Dictionary) -> bool:
    """Verifica se os algoritmos atingem performance adequada"""
    var puzzle_id = puzzle.get("id", "")
    
    if "machine_learning" in puzzle_id:
        var accuracy = calculate_simulated_accuracy()
        return accuracy >= 0.7  # Threshold mínimo
    elif "deep_learning" in puzzle_id:
        var accuracy = calculate_simulated_accuracy()
        return accuracy >= 0.8  # Threshold mais alto para deep learning
    elif "big_data" in puzzle_id:
        # Verificar eficiência de processamento
        return moves_used <= target_moves * 1.2  # Dentro do limite eficiente
    
    return true

func load_next_puzzle():
    """Carrega o próximo puzzle data science"""
    if current_puzzle_index >= available_puzzles.size():
        return
    
    var next_puzzle = available_puzzles[current_puzzle_index]
    
    # Resetar estado
    moves_used = 0
    blocks_placed = 0
    
    # Limpar pipelines anteriores
    clear_data_pipeline()
    
    # Atualizar UI
    update_puzzle_display(next_puzzle)
    
    # Configurar novo puzzle
    setup_puzzle_obstacles(next_puzzle.get("obstacles", []))

func clear_data_pipeline():
    """Limpa pipelines de dados anteriores"""
    data_processing_pipeline.clear()
    ml_models.clear()
    # Implementar limpeza de outros recursos

func update_puzzle_display(puzzle: Dictionary):
    """Atualiza a exibição do puzzle data science"""
    var puzzle_title = puzzle.get("title", "")
    var puzzle_desc = puzzle.get("description", "")
    var datasets_info = ""
    
    if puzzle.has("datasets"):
        var datasets = puzzle.get("datasets", [])
        datasets_info = " | Datasets: %d" % datasets.size()
    
    if puzzle_info_label:
        puzzle_info_label.text = "%s: %s%s" % [puzzle_title, puzzle_desc, datasets_info]
    
    if progress_bar:
        var progress = float(current_puzzle_index) / float(available_puzzles.size())
        progress_bar.value = progress * 100

# Manipuladores de eventos
func _on_block_dropped(block: LogicBlock, position: Vector2i):
    """Manipula quando um bloco é solto no contexto data science"""
    blocks_placed += 1
    moves_used += 1
    emit_signal("move_made")
    
    # Validação específica para data science
    var current_puzzle = available_puzzles[current_puzzle_index]
    validate_data_science_block_placement(block, current_puzzle)
    
    # Emitir sinal de processamento de dados se apropriado
    if is_data_processing_block(block):
        emit_signal("data_processed", {
            "block": block,
            "puzzle": current_puzzle,
            "position": position
        })

func _on_player_move_completed():
    """Manipula quando o jogador completa um movimento"""
    emit_signal("move_made")
    check_level_completion()

func _on_pause_requested():
    """Manipula pedidos de pausa"""
    is_timer_running = !is_timer_running

func validate_data_science_block_placement(block: LogicBlock, puzzle: Dictionary):
    """Valida se o bloco foi colocado corretamente no contexto data science"""
    var concepts = puzzle.get("concepts", [])
    var block_concept = block.get("custom_data", {}).get("concept", "")
    var block_type = block.get("block_type", "")
    
    # Verificar relevância do conceito
    var is_valid_concept = concepts.has(block_concept) or "generic" in concepts
    
    # Verificar se o tipo de bloco é apropriado
    var is_valid_type = is_valid_block_type_for_puzzle(block_type, puzzle.get("id", ""))
    
    if not is_valid_concept or not is_valid_type:
        block.highlight_as_invalid()

func is_valid_block_type_for_puzzle(block_type: String, puzzle_id: String) -> bool:
    """Verifica se o tipo de bloco é válido para o puzzle"""
    match puzzle_id:
        "machine_learning_pipeline":
            return block_type in ["concept", "ml_category"]
        "deep_learning_neural":
            return block_type in ["concept", "data_type"]
        "big_data_processing":
            return block_type in ["concept", "data_type"]
        "advanced_analytics_algorithms":
            return block_type in ["concept", "ml_category"]
        "model_deployment_production":
            return block_type in ["concept"]
        _:
            return true

func is_data_processing_block(block: LogicBlock) -> bool:
    """Verifica se o bloco representa processamento de dados"""
    var processing_concepts = [
        "pandas", "numpy", "data visualization", "statistical analysis",
        "feature engineering", "data cleaning", "data transformation"
    ]
    
    var block_concept = block.get("custom_data", {}).get("concept", "").to_lower()
    
    for concept in processing_concepts:
        if concept in block_concept:
            return true
    
    return false

# Funções utilitárias
func get_random_valid_position() -> Vector2i:
    """Retorna uma posição válida aleatória no tabuleiro data science"""
    var attempts = 0
    var max_attempts = 100
    
    while attempts < max_attempts:
        var x = randi_range(1, grid_width - 2)
        var y = randi_range(1, grid_height - 2)
        var position = Vector2i(x, y)
        
        if is_position_available(position):
            return position
        
        attempts += 1
    
    return Vector2i(6, 14)

func is_position_available(position: Vector2i) -> bool:
    """Verifica se uma posição está disponível"""
    # Implementar verificação de colisões data science
    return true

# Funções de interface pública
func get_current_score() -> Dictionary:
    """Retorna a pontuação atual do nível data science"""
    var time_score = max(0, 1500 - int(level_timer * 12))
    var efficiency_score = max(0, (target_moves * 120) - (moves_used * 15))
    var concept_score = calculate_data_science_concept_score()
    var performance_score = calculate_data_performance_score()
    var quality_score = calculate_data_quality_score()
    
    return {
        "time_score": time_score,
        "efficiency_score": efficiency_score,
        "concept_score": concept_score,
        "performance_score": performance_score,
        "quality_score": quality_score,
        "total_score": time_score + efficiency_score + concept_score + performance_score + quality_score
    }

func calculate_data_science_concept_score() -> int:
    """Calcula pontuação baseada em conceitos data science implementados"""
    var total_concepts = 0
    var mastered_concepts = 0
    
    for puzzle in available_puzzles:
        var concepts = puzzle.get("concepts", [])
        total_concepts += concepts.size()
        
        # Verificar conceitos implementados
        mastered_concepts += int(concepts.size() * 0.8)  # 80% implementado
    
    if total_concepts > 0:
        return int((mastered_concepts * 120) / total_concepts)
    return 0

func calculate_data_performance_score() -> int:
    """Calcula pontuação baseada na performance dos algoritmos"""
    var accuracy = calculate_simulated_accuracy()
    var precision = calculate_simulated_precision()
    var recall = calculate_simulated_recall()
    
    var f1_score = 2 * (precision * recall) / (precision + recall)
    return int(f1_score * 100)

func calculate_data_quality_score() -> int:
    """Calcula pontuação baseada na qualidade dos dados"""
    var current_puzzle = available_puzzles[current_puzzle_index]
    var obstacles = current_puzzle.get("obstacles", [])
    
    var quality_factors = []
    
    for obstacle in obstacles:
        var obstacle_type = obstacle.get("type", "")
        
        match obstacle_type:
            "missing_data":
                var missing_pct = obstacle.get("missing_percentage", 0)
                quality_factors.append(max(0, 100 - missing_pct))
            "outliers":
                quality_factors.append(75)  # Score médio para outliers
            "data_type_inconsistency":
                quality_factors.append(80)  # Score médio para inconsistência
    
    if quality_factors.size() > 0:
        var avg_quality = 0.0
        for factor in quality_factors:
            avg_quality += factor
        avg_quality /= quality_factors.size()
        return int(avg_quality)
    
    return 85  # Score padrão

func get_level_stats() -> Dictionary:
    """Retorna estatísticas detalhadas do nível data science"""
    return {
        "level": 8,
        "name": level_name,
        "description": level_description,
        "target_moves": target_moves,
        "moves_used": moves_used,
        "puzzles_completed": current_puzzle_index,
        "total_puzzles": available_puzzles.size(),
        "time_elapsed": level_timer,
        "blocks_placed": blocks_placed,
        "concepts_mastered": get_mastered_concepts(),
        "data_science_technologies": get_data_science_technologies(),
        "algorithms_implemented": get_implemented_algorithms(),
        "datasets_processed": get_processed_datasets(),
        "performance_metrics": get_performance_metrics(),
        "quality_metrics": get_quality_metrics(),
        "score": get_current_score()
    }

func get_mastered_concepts() -> Array:
    """Retorna conceitos data science que foram dominados"""
    var mastered = []
    
    for i in range(current_puzzle_index):
        var puzzle = available_puzzles[i]
        var concepts = puzzle.get("concepts", [])
        mastered.append_array(concepts)
    
    return mastered

func get_data_science_technologies() -> Dictionary:
    """Retorna tecnologias data science utilizadas"""
    return {
        "data_processing": ["Pandas", "NumPy", "Dask", "Apache Spark"],
        "machine_learning": ["Scikit-learn", "XGBoost", "LightGBM", "CatBoost"],
        "deep_learning": ["TensorFlow", "PyTorch", "Keras", "MXNet"],
        "big_data": ["Apache Spark", "Hadoop", "Kafka", "Flink"],
        "visualization": ["Matplotlib", "Seaborn", "Plotly", "D3.js"],
        "cloud_platforms": ["AWS SageMaker", "Google AI Platform", "Azure ML"],
        "databases": ["PostgreSQL", "MongoDB", "Redis", "Elasticsearch"]
    }

func get_implemented_algorithms() -> Array:
    """Retorna algoritmos que foram implementados"""
    var algorithms = []
    
    for puzzle in available_puzzles:
        if puzzle.has("algorithms"):
            algorithms.append_array(puzzle.get("algorithms", []))
    
    return algorithms

func get_processed_datasets() -> Array:
    """Retorna datasets processados"""
    var datasets = []
    
    for puzzle in available_puzzles:
        if puzzle.has("datasets"):
            datasets.append_array(puzzle.get("datasets", []))
    
    return datasets

func get_performance_metrics() -> Dictionary:
    """Retorna métricas de performance"""
    return {
        "model_accuracy": calculate_simulated_accuracy(),
        "model_precision": calculate_simulated_precision(),
        "model_recall": calculate_simulated_recall(),
        "processing_speed": "1.2GB/min",
        "memory_efficiency": "%dGB" % estimate_memory_usage(),
        "cpu_utilization": "%d%%" % estimate_cpu_usage()
    }

func get_quality_metrics() -> Dictionary:
    """Retorna métricas de qualidade dos dados"""
    return {
        "data_completeness": "85%",
        "data_consistency": "92%",
        "outlier_detection": "Identificados e tratados",
        "missing_data_handling": "Imputação aplicada",
        "feature_engineering": "%d features criadas" % (moves_used * 2)
    }

# Função de cleanup
func cleanup():
    """Limpa recursos do nível data science"""
    is_timer_running = false
    
    # Limpar pipelines e modelos
    data_processing_pipeline.clear()
    ml_models.clear()
    
    # Remover todos os blocos
    for child in get_children():
        if child is LogicBlock:
            child.queue_free()
    
    print("Level 8: A Ciência dos Dados - Limpeza concluída")
func _exit_tree():
    print("🧹 Level'${level_num}': Cleanup automático")
    concepts.clear()
    containers.clear()
    deployments.clear()
    services.clear()

func _initialize_concept_cache():
    _initialize_object_pool()
    print("📦 Level'${level_num}': Cache de conceitos inicializado")
    # Cache de conceitos para performance

func _initialize_object_pool():
    for i in _object_pool_size:
        _resource_pool.append({"id": "resource_" + str(i), "status": "available"})
    print("🎯 Level'${level_num}': Object pool inicializado")

func acquire_resource() -> Dictionary:
    return _resource_pool.pop_back() if _resource_pool.size() > 0 else {"id": "new_resource", "status": "created"}

func return_resource(resource: Dictionary):
    resource["status"] = "available"
    _resource_pool.append(resource)
