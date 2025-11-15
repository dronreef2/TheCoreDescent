# THE CORE DESCENT - NÍVEL 12: A FORTALEZA DIGITAL (CYBERSECURITY)
# Arquivo: Level12.gd - Cybersecurity: Cryptography, Firewalls, IDS, Malware Analysis
# VERSÃO OTIMIZADA: PackedStringArray, Signals, Object Pooling, Cache

extends Node2D
class_name Level12

# Configurações do nível
@export var level_name: String = "A Fortaleza Digital"
@export var level_description: String = "Proteja sistemas contra ciberataques com criptografia e segurança avançada"
@export var target_moves: int = 68  # Número ideal de movimentos
@export var grid_width: int = 42
@export var grid_height: int = 36

# Referências aos sistemas
var game_manager: Node
var drag_system: DragAndDropSystem
var player: PlayerController
var ui_manager: Node
var ability_system: Node

# Estado do nível
enum LevelState { LOADING, PLAYING, COMPLETED, FAILED }
var current_state: LevelState = LevelState.LOADING

# Dados do nível - OTIMIZADO: Usar Vector2i para grid
var start_position: Vector2i = Vector2i(2, 18)
var goal_position: Vector2i = Vector2i(39, 18)
var start_block: LogicBlock
var goal_block: LogicBlock

# Objetivo atual - OTIMIZADO: Contadores eficientes
var moves_used: int = 0
var blocks_placed: int = 0
var level_timer: float = 0.0
var is_timer_running: bool = false
var ability_used_count: Dictionary = {}

# === OTIMIZAÇÃO 1: PACKED ARRAYS PARA CONCEITOS ===
# Cache de conceitos usando PackedStringArray (mais eficiente que Array)
var _cached_concepts: Dictionary = {}
var _concept_cache_initialized: bool = false

# === OTIMIZAÇÃO 2: OBJECT POOLING PARA RECURSOS TEMPORÁRIOS ===
var _encryption_pool: Array = []
var _firewall_pool: Array = []
var _monitoring_pool: Array = []
var _analysis_pool: Array = []
var _object_pool_size: int = 20

# Recursos de segurança - OTIMIZADO: Inicialização eficiente
var security_infrastructure: Dictionary = {}
var threat_intelligence: Dictionary = {}
var incident_response: Array = []
var compliance_policies: Array = []

# Puzzles disponíveis - OTIMIZADO: Cache de dados
var available_puzzles: Array[Dictionary] = []
var current_puzzle_index: int = 0
var _puzzles_cache_initialized: bool = false

# UI Elements
var move_counter: Label
var timer_label: Label
var puzzle_info_label: Label
var progress_bar: ProgressBar
var security_panel: Control
var threat_monitoring: Control
var vulnerability_scanner: Control

# === OTIMIZAÇÃO 3: SIGNALS OTIMIZADOS ===
# Signals consolidados para reduzir overhead
signal level_state_changed(new_state: LevelState)
signal performance_metrics_updated(metrics: Dictionary)
signal resource_pool_utilization(pool_name: String, utilization: float)
signal puzzle_efficiency_calculated(puzzle_id: String, efficiency: float)

# Sinais específicos mantidos para funcionalidade
signal level_completed
signal level_failed
signal puzzle_solved(puzzle_data: Dictionary)
signal move_made
signal ability_activated

# === OTIMIZAÇÃO 4: INICIALIZAÇÃO CACHEADA ===
func _ready():
    print("🔒 Level12: Inicializando A Fortaleza Digital...")
    
    # Cache de conceitos para performance
    _initialize_concept_cache()
    
    # Object pools para recursos temporários
    _initialize_object_pools()
    
    # Cache de puzzles
    if not _puzzles_cache_initialized:
        _initialize_puzzles()
    
    # Conectar sinais otimizados
    _connect_optimized_signals()
    
    print("✅ Level12: Otimizações de segurança aplicadas com sucesso!")

# === FUNÇÃO OTIMIZADA: CACHE DE CONCEITOS ===
func _initialize_concept_cache():
    if _concept_cache_initialized:
        return
    
    # Cache de conceitos Cybersecurity usando PackedStringArray
    _cached_concepts = {
        "cryptography_concepts": PackedStringArray([
            "Symmetric Encryption", "Asymmetric Encryption", "Hash Functions", "Digital Signatures",
            "Public Key Infrastructure", "Certificate Authority", "Key Management", "Encryption Algorithms",
            "Data Classification", "Encryption at Rest", "Encryption in Transit", "Key Exchange",
            "SSL/TLS Protocols", "Homomorphic Encryption", "Quantum Cryptography", "Zero-Knowledge Proofs",
            "Perfect Forward Secrecy", "Cryptographic Hashes", "Stream Ciphers", "Block Ciphers"
        ]),
        "firewall_concepts": PackedStringArray([
            "Network Firewall", "Application Firewall", "Packet Filtering", "Stateful Inspection",
            "Deep Packet Inspection", "Next-Generation Firewall", "Web Application Firewall", "Host-Based Firewall",
            "Network Address Translation", "Port Security", "Protocol Analysis", "Traffic Shaping",
            "Intrusion Prevention", "Application Control", "URL Filtering", "Antivirus Integration",
            "VPN Termination", "SSL Inspection", "Threat Intelligence Feed", "Firewall Rules Management"
        ]),
        "ids_concepts": PackedStringArray([
            "Intrusion Detection System", "Network Intrusion Detection", "Host Intrusion Detection",
            "Signature-Based Detection", "Anomaly Detection", "Behavior Analysis", "False Positive Reduction",
            "Alert Correlation", "SIEM Integration", "Threat Hunting", "Network Traffic Analysis",
            "Log Analysis", "Forensic Investigation", "Malware Detection", "Brute Force Detection",
            "DDoS Detection", "Network Segmentation", "Zero-Day Detection", "Machine Learning Detection"
        ]),
        "malware_concepts": PackedStringArray([
            "Malware Analysis", "Static Analysis", "Dynamic Analysis", "Sandbox Environment",
            "Reverse Engineering", "Code Analysis", "Behavioral Analysis", "Signature Extraction",
            "YARA Rules", "Threat Intelligence", "IoC Analysis", "Attribution", "Campaign Tracking",
            "File Hashing", "Packer Detection", "Anti-Debugging", "Rootkit Detection", "Trojan Analysis",
            "Ransomware Analysis", "Cryptographic Indicators", "C2 Communication Detection"
        ]),
        "pentesting_concepts": PackedStringArray([
            "Penetration Testing", "Vulnerability Assessment", "Reconnaissance", "Information Gathering",
            "Port Scanning", "Service Enumeration", "Vulnerability Scanning", "Exploitation", "Privilege Escalation",
            "Post-Exploitation", "Lateral Movement", "Data Exfiltration", "Report Writing", "OWASP Top 10",
            "Web Application Testing", "Network Penetration", "Social Engineering", "Physical Security",
            "Mobile Security Testing", "API Security Testing", "Cloud Security Assessment"
        ]),
        "incident_response_concepts": PackedStringArray([
            "Incident Response", "NIST Cybersecurity Framework", "Kill Chain Analysis", "MITRE ATT&CK",
            "Forensic Analysis", "Chain of Custody", "Evidence Collection", "Log Analysis", "Timeline Construction",
            "Threat Attribution", "Containment Strategy", "Eradication Planning", "Recovery Procedures",
            "Communication Plan", "Legal Considerations", "Compliance Reporting", "Lessons Learned",
            "Root Cause Analysis", "Process Improvement", "Training and Awareness"
        ]),
        "iam_concepts": PackedStringArray([
            "Identity Management", "Access Control", "Role-Based Access Control", "Attribute-Based Access Control",
            "Principle of Least Privilege", "Zero Trust Model", "Multi-Factor Authentication", "Single Sign-On",
            "Privileged Access Management", "Identity Federation", "OAuth 2.0", "SAML", "LDAP Integration",
            "Active Directory", "Certificate Management", "Password Policy", "Session Management",
            "Account Lifecycle", "Access Reviews", "SoD Violations", "Identity Governance"
        ]),
        "siem_concepts": PackedStringArray([
            "Security Information and Event Management", "Log Aggregation", "Correlation Rules", "Alert Tuning",
            "Threat Intelligence", "User Behavior Analytics", "Anomaly Detection", "Data Loss Prevention",
            "Compliance Monitoring", "Security Dashboards", "Incident Management", "Workflow Automation",
            "Retention Policies", "Query Optimization", "Performance Monitoring", "Backup and Recovery",
            "Integration APIs", "Custom Content Development", "Threat Hunting", "Mitre ATT&CK Integration"
        ])
    }
    
    _concept_cache_initialized = true
    print("🔐 Level12: Cache de conceitos cybersecurity inicializado")

# === FUNÇÃO OTIMIZADA: OBJECT POOLING ===
func _initialize_object_pools():
    # Pool para recursos de criptografia
    for i in _object_pool_size:
        _encryption_pool.append({
            "id": "encryption_session_" + str(i),
            "status": "available",
            "algorithm": "AES-256",
            "key_strength": 256,
            "created_at": Time.get_unix_time_from_system()
        })
    
    # Pool para regras de firewall
    for i in _object_pool_size:
        _firewall_pool.append({
            "id": "firewall_rule_" + str(i),
            "status": "available",
            "rule_type": "allow",
            "protocol": "tcp",
            "port_range": "80,443"
        })
    
    # Pool para sistemas de monitoramento
    for i in _object_pool_size:
        _monitoring_pool.append({
            "id": "monitoring_agent_" + str(i),
            "status": "available",
            "sensor_type": "network",
            "log_level": "info",
            "coverage_percentage": 100.0
        })
    
    # Pool para análise de malware
    for i in _object_pool_size:
        _analysis_pool.append({
            "id": "analysis_job_" + str(i),
            "status": "available",
            "analysis_type": "static",
            "risk_level": "low",
            "processing_time": 0
        })
    
    print("🛡️ Level12: Object pools de segurança inicializados (tamanho: " + str(_object_pool_size) + ")")

# === FUNÇÃO OTIMIZADA: ACQUISITION DE OBJETOS DO POOL ===
func acquire_resource_from_pool(pool_name: String) -> Dictionary:
    match pool_name:
        "encryption":
            var encryption = _encryption_pool.pop_back()
            if encryption == null:
                encryption = {"id": "encryption_session_new", "status": "created", "algorithm": "AES-128"}
            return encryption
        "firewall":
            var firewall = _firewall_pool.pop_back()
            if firewall == null:
                firewall = {"id": "firewall_rule_new", "status": "created", "rule_type": "deny", "protocol": "tcp"}
            return firewall
        "monitoring":
            var monitoring = _monitoring_pool.pop_back()
            if monitoring == null:
                monitoring = {"id": "monitoring_agent_new", "status": "created", "sensor_type": "host"}
            return monitoring
        "analysis":
            var analysis = _analysis_pool.pop_back()
            if analysis == null:
                analysis = {"id": "analysis_job_new", "status": "created", "analysis_type": "dynamic"}
            return analysis
        _:
            return {"id": "unknown_resource", "status": "error"}

# === FUNÇÃO OTIMIZADA: RETURN DE OBJETOS AO POOL ===
func return_resource_to_pool(pool_name: String, resource: Dictionary):
    resource["status"] = "available"
    match pool_name:
        "encryption":
            _encryption_pool.append(resource)
        "firewall":
            _firewall_pool.append(resource)
        "monitoring":
            _monitoring_pool.append(resource)
        "analysis":
            _analysis_pool.append(resource)

# === FUNÇÃO OTIMIZADA: SIGNALS OTIMIZADOS ===
func _connect_optimized_signals():
    # Conectar sinais de performance
    var performance_timer = Timer.new()
    performance_timer.wait_time = 3.0  # Atualizar a cada 3 segundos para Cybersecurity
    performance_timer.connect("timeout", Callable(self, "_update_performance_metrics"))
    add_child(performance_timer)
    performance_timer.start()
    
    # Conectar sinais de eficiência de puzzles
    self.connect("puzzle_solved", Callable(self, "_on_puzzle_solved_optimized"))

func _update_performance_metrics():
    var metrics = {
        "encryption_pool_utilization": float(_object_pool_size - _encryption_pool.size()) / _object_pool_size,
        "firewall_pool_utilization": float(_object_pool_size - _firewall_pool.size()) / _object_pool_size,
        "monitoring_pool_utilization": float(_object_pool_size - _monitoring_pool.size()) / _object_pool_size,
        "analysis_pool_utilization": float(_object_pool_size - _analysis_pool.size()) / _object_pool_size,
        "memory_usage_mb": OS.get_static_memory_usage() / 1024 / 1024,
        "active_puzzle_count": available_puzzles.size(),
        "threat_level": "medium"  # Cybersecurity threat level
    }
    emit_signal("performance_metrics_updated", metrics)

# === FUNÇÃO OTIMIZADA: PROCESSAMENTO DE PUZZLE ===
func _on_puzzle_solved_optimized(puzzle_data: Dictionary):
    # Calcular eficiência do puzzle
    var efficiency = float(target_moves) / float(moves_used) if moves_used > 0 else 1.0
    emit_signal("puzzle_efficiency_calculated", puzzle_data.get("id", "unknown"), efficiency)
    
    # Retornar recursos ao pool após resolver puzzle
    _cleanup_puzzle_resources(puzzle_data)

func _cleanup_puzzle_resources(puzzle_data: Dictionary):
    # Limpar recursos temporários do puzzle
    var puzzle_id = puzzle_data.get("id", "")
    
    match puzzle_id:
        "cryptography_implementation":
            # Retornar sessões de criptografia ao pool
            for i in range(min(3, _encryption_pool.size() + 3)):
                var encryption = {"id": "temp_encryption_" + str(i), "status": "cleanup"}
                return_resource_to_pool("encryption", encryption)
        
        "firewall_configuration":
            # Retornar regras de firewall ao pool
            for i in range(min(5, _firewall_pool.size() + 5)):
                var firewall = {"id": "temp_firewall_" + str(i), "status": "cleanup"}
                return_resource_to_pool("firewall", firewall)

# === FUNÇÃO OTIMIZADA: GET CONCEITOS COM CACHE ===
func get_concepts_for_puzzle(puzzle_type: String) -> PackedStringArray:
    if not _concept_cache_initialized:
        _initialize_concept_cache()
    
    return _cached_concepts.get(puzzle_type + "_concepts", PackedStringArray())

# === FUNÇÃO OTIMIZADA: ATUALIZAÇÃO DE PERFORMANCE ===
func _process(delta: float) -> void:
    if is_timer_running:
        level_timer += delta
        if timer_label:
            timer_label.text = "Tempo: %.1fs" % level_timer
    
    # Atualizar métricas de performance periodicamente
    if int(level_timer) % 15 == 0 and int((level_timer - delta) * 10) % 10 != 0:
        _update_performance_metrics()

# === FUNÇÃO PRINCIPAL OTIMIZADA ===
func _initialize_puzzles():
    if _puzzles_cache_initialized:
        return
    
    available_puzzles = [
        {
            "id": "cryptography_implementation",
            "title": "Implementação de Criptografia",
            "description": "Configure criptografia forte para proteger dados sensíveis",
            "target_moves": 58,
            "start_position": Vector2i(2, 8),
            "goal_position": Vector2i(20, 28),
            "blocks_required": 18,
            # OTIMIZADO: Usar cache de conceitos em vez de array dinâmico
            "concepts": get_concepts_for_puzzle("cryptography"),
            "mechanics": {
                "encryption_setup": true,
                "key_management": true,
                "certificate_authority": true,
                "secure_transmission": true,
                "data_classification": true,
                "crypto_algorithm_selection": true,
                "key_rotation": true,
                "secure_storage": true
            },
            "obstacles": [
                {"type": "weak_key_management", "position": Vector2i(6, 12), "key_vulnerability": "AES-128"},
                {"type": "certificate_expired", "position": Vector2i(10, 16), "expired_days": 15},
                {"type": "protocol_vulnerability", "position": Vector2i(14, 20), "ssl_tls_version": "1.1"},
                {"type": "crypto_library_conflict", "position": Vector2i(18, 24), "conflicts": 4}
            ]
        },
        {
            "id": "firewall_configuration",
            "title": "Configuração de Firewall Avançado",
            "description": "Configure regras de firewall para proteger a rede contra ameaças",
            "target_moves": 60,
            "start_position": Vector2i(4, 30),
            "goal_position": Vector2i(24, 6),
            "blocks_required": 19,
            # OTIMIZADO: Usar cache de conceitos
            "concepts": get_concepts_for_puzzle("firewall"),
            "mechanics": {
                "network_segmentation": true,
                "traffic_filtering": true,
                "application_control": true,
                "threat_prevention": true,
                "vpn_configuration": true,
                "url_filtering": true,
                "ssl_inspection": true,
                "rule_optimization": true
            },
            "obstacles": [
                {"type": "open_ports_exposed", "position": Vector2i(8, 26), "exposed_ports": [22, 3389, 8080]},
                {"type": "firewall_rule_conflict", "position": Vector2i(12, 20), "conflicting_rules": 6},
                {"type": "bandwidth_saturation", "position": Vector2i(16, 14), "saturation_percentage": 85},
                {"type": "false_positive_alerts", "position": Vector2i(20, 8), "false_positive_rate": 0.4}
            ]
        },
        {
            "id": "ids_deployment",
            "title": "Deploy de Sistema de Detecção",
            "description": "Implemente IDS/IPS para detectar e prevenir intrusões",
            "target_moves": 62,
            "start_position": Vector2i(22, 4),
            "goal_position": Vector2i(38, 30),
            "blocks_required": 20,
            # OTIMIZADO: Usar cache de conceitos
            "concepts": get_concepts_for_puzzle("ids"),
            "mechanics": {
                "network_monitoring": true,
                "signature_configuration": true,
                "anomaly_detection": true,
                "alert_correlation": true,
                "threat_intelligence": true,
                "behavior_analysis": true,
                "false_positive_tuning": true,
                "real_time_response": true
            },
            "obstacles": [
                {"type": "signature_database_outdated", "position": Vector2i(26, 8), "outdated_signatures": 1250},
                {"type": "alert_flooding", "position": Vector2i(30, 16), "alerts_per_hour": 5000},
                {"type": "detection_gaps", "position": Vector2i(34, 24), "coverage_percentage": 75},
                {"type": "performance_degradation", "position": Vector2i(36, 28), "cpu_usage": 90}
            ]
        },
        {
            "id": "malware_analysis",
            "title": "Análise Avançada de Malware",
            "description": "Analise malware em sandbox e extraia indicadores de compromisso",
            "target_moves": 64,
            "start_position": Vector2i(8, 32),
            "goal_position": Vector2i(28, 4),
            "blocks_required": 21,
            # OTIMIZADO: Usar cache de conceitos
            "concepts": get_concepts_for_puzzle("malware"),
            "mechanics": {
                "sandbox_analysis": true,
                "static_analysis": true,
                "dynamic_analysis": true,
                "signature_extraction": true,
                "behavioral_tracking": true,
                "yara_rule_creation": true,
                "attribution_analysis": true,
                "threat_intelligence": true
            },
            "obstacles": [
                {"type": "sandbox_evasion", "position": Vector2i(12, 28), "evasion_techniques": 3},
                {"type": "packed_malware", "position": Vector2i(16, 22), "packer_type": "UPX"},
                {"type": "encrypted_strings", "position": Vector2i(20, 16), "encrypted_percentage": 85},
                {"type": "c2_communication", "position": Vector2i(24, 10), "c2_domains": [2, 4, 6, 8]}
            ]
        },
        {
            "id": "penetration_testing",
            "title": "Teste de Penetração Profissional",
            "description": "Execute pentest abrangente seguindo metodologia OWASP",
            "target_moves": 66,
            "start_position": Vector2i(30, 10),
            "goal_position": Vector2i(40, 28),
            "blocks_required": 22,
            # OTIMIZADO: Usar cache de conceitos
            "concepts": get_concepts_for_puzzle("pentesting"),
            "mechanics": {
                "reconnaissance": true,
                "vulnerability_scanning": true,
                "exploitation": true,
                "privilege_escalation": true,
                "lateral_movement": true,
                "post_exploitation": true,
                "report_generation": true,
                "remediation": true
            },
            "obstacles": [
                {"type": "waf_protection", "position": Vector2i(32, 14), "waf_rules": 150},
                {"type": "network_segmentation", "position": Vector2i(34, 18), "isolated_segments": 5},
                {"type": "privilege_escalation_required", "position": Vector2i(36, 22), "escalation_methods": 4},
                {"type": "audit_logging", "position": Vector2i(38, 26), "log_sensitivity": "high"}
            ]
        },
        {
            "id": "incident_response",
            "title": "Resposta a Incidentes de Segurança",
            "description": "Execute resposta a incidentes seguindo NIST e MITRE ATT&CK",
            "target_moves": 68,
            "start_position": Vector2i(10, 6),
            "goal_position": Vector2i(36, 32),
            "blocks_required": 23,
            # OTIMIZADO: Usar cache de conceitos
            "concepts": get_concepts_for_puzzle("incident_response"),
            "mechanics": {
                "incident_identification": true,
                "containment_strategy": true,
                "evidence_collection": true,
                "forensic_analysis": true,
                "threat_attribution": true,
                "eradication_planning": true,
                "recovery_procedures": true,
                "lessons_learned": true
            },
            "obstacles": [
                {"type": "distributed_attack", "position": Vector2i(14, 10), "attack_vectors": 6},
                {"type": "data_retention_requirement", "position": Vector2i(18, 18), "retention_days": 2555},
                {"type": "jurisdictional_complexity", "position": Vector2i(22, 26), "jurisdictions": 3},
                {"type": "compliance_reporting", "position": Vector2i(28, 30), "regulatory_requirements": 8}
            ]
        }
    ]
    
    _puzzles_cache_initialized = true
    print("🛡️ Level12: Puzzles de cybersecurity otimizados inicializados (cache: " + str(available_puzzles.size()) + " puzzles)")

# === FUNÇÃO OTIMIZADA: LÓGICA PRINCIPAL ===
func start_level():
    current_state = LevelState.PLAYING
    emit_signal("level_state_changed", current_state)
    is_timer_running = true
    _update_ui()
    print("🔒 Level12: Iniciando A Fortaleza Digital!")

func check_puzzle_completion() -> bool:
    # OTIMIZADO: Verificação eficiente usando cache
    var current_puzzle = available_puzzles[current_puzzle_index] if current_puzzle_index < available_puzzles.size() else null
    
    if current_puzzle and blocks_placed >= current_puzzle.blocks_required:
        moves_used = current_puzzle.target_moves  # Meta alcançada
        emit_signal("puzzle_solved", current_puzzle)
        current_puzzle_index += 1
        
        if current_puzzle_index >= available_puzzles.size():
            current_state = LevelState.COMPLETED
            emit_signal("level_completed")
            print("🏆 Level12: Todas as defesas da fortaleza digital ativadas! Sistemas seguros.")
            return true
    
    return false

func _update_ui():
    if move_counter:
        move_counter.text = "Movimentos: %d/%d" % [moves_used, target_moves]
    
    if progress_bar:
        progress_bar.value = (float(current_puzzle_index) / available_puzzles.size()) * 100
    
    if puzzle_info_label and current_puzzle_index < available_puzzles.size():
        var puzzle_data = available_puzzles[current_puzzle_index]
        puzzle_info_label.text = "Puzzle %d/6\n%s\nObjetivo: %d movimentos" % [
            current_puzzle_index + 1, 
            puzzle_data.title, 
            puzzle_data.target_moves
        ]

# === FUNÇÃO OTIMIZADA: LIMPEZA DE MEMÓRIA ===
func _exit_tree():
    # OTIMIZADO: Cleanup automático de recursos
    print("🧹 Level12: Limpando object pools e cache de segurança...")
    
    # Limpar caches
    _cached_concepts.clear()
    _concept_cache_initialized = false
    _puzzles_cache_initialized = false
    
    # Limpar object pools
    _encryption_pool.clear()
    _firewall_pool.clear()
    _monitoring_pool.clear()
    _analysis_pool.clear()
    
    # Parar timer de performance
    is_timer_running = false
    
    print("✅ Level12: Cleanup de segurança otimizado concluído")
