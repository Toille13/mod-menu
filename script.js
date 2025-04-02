document.addEventListener('DOMContentLoaded', function() {
    // Initialize Feather icons
    feather.replace();
    
    // Menu Toggle Functionality
    const menuToggle = document.getElementById('menu-toggle');
    const modMenu = document.getElementById('mod-menu');
    
    menuToggle.addEventListener('click', function() {
        modMenu.classList.toggle('collapsed');
    });
    
    // Save Settings Button
    const saveSettingsBtn = document.getElementById('save-settings');
    saveSettingsBtn.addEventListener('click', function() {
        // Simulate saving settings
        const savingText = saveSettingsBtn.textContent;
        saveSettingsBtn.textContent = 'Saving...';
        saveSettingsBtn.disabled = true;
        
        setTimeout(() => {
            saveSettingsBtn.textContent = 'Saved!';
            
            setTimeout(() => {
                saveSettingsBtn.textContent = savingText;
                saveSettingsBtn.disabled = false;
            }, 1000);
        }, 800);
        
        // Get all settings and log them
        const settings = {
            jump: {
                enabled: document.getElementById('jump-toggle').checked,
                height: document.getElementById('jump-height-slider').value
            },
            fly: {
                enabled: document.getElementById('fly-toggle').checked,
                speed: document.getElementById('fly-speed-slider').value
            },
            aimbot: {
                enabled: document.getElementById('aimbot-toggle').checked,
                smoothness: document.getElementById('aimbot-smoothness').value,
                target: document.querySelector('input[name="aimbot-target"]:checked').value,
                visibleOnly: document.getElementById('aimbot-visible-only').checked,
                lockTarget: document.getElementById('aimbot-lock-target').checked
            },
            teleport: {
                enabled: document.getElementById('teleport-toggle').checked,
                type: document.querySelector('input[name="teleport-type"]:checked').value
            },
            esp: {
                enabled: document.getElementById('esp-toggle').checked,
                color: document.querySelector('.color-option.selected').dataset.color,
                showHealth: document.getElementById('esp-show-health').checked,
                showDistance: document.getElementById('esp-show-distance').checked,
                showName: document.getElementById('esp-show-name').checked
            },
            wallHack: {
                enabled: document.getElementById('wallhack-toggle').checked,
                transparency: document.getElementById('wall-transparency').value
            }
        };
        
        console.log('Settings saved (demonstration only):', settings);
    });
    
    // Toggle dependent options visibility
    function setupToggleVisibility(toggleId, containerId) {
        const toggle = document.getElementById(toggleId);
        const container = document.getElementById(containerId);
        
        // Initialize visibility
        container.style.display = toggle.checked ? 'block' : 'none';
        
        // Add event listener
        toggle.addEventListener('change', function() {
            container.style.display = this.checked ? 'block' : 'none';
        });
    }
    
    setupToggleVisibility('jump-toggle', 'jump-slider-container');
    setupToggleVisibility('fly-toggle', 'fly-slider-container');
    setupToggleVisibility('aimbot-toggle', 'aimbot-options');
    setupToggleVisibility('esp-toggle', 'esp-options');
    setupToggleVisibility('teleport-toggle', 'teleport-options');
    setupToggleVisibility('wallhack-toggle', 'wallhack-options');
    
    // Value display for sliders
    function setupSliderValueDisplay(sliderId, valueId, suffix = '') {
        const slider = document.getElementById(sliderId);
        const valueDisplay = document.getElementById(valueId);
        
        valueDisplay.textContent = slider.value + suffix;
        
        slider.addEventListener('input', function() {
            valueDisplay.textContent = this.value + suffix;
        });
    }
    
    setupSliderValueDisplay('jump-height-slider', 'jump-height-value', 'x');
    setupSliderValueDisplay('fly-speed-slider', 'fly-speed-value', 'x');
    setupSliderValueDisplay('aimbot-smoothness', 'aimbot-smoothness-value');
    setupSliderValueDisplay('wall-transparency', 'wall-transparency-value', '%');
    
    // Color picker functionality
    const colorOptions = document.querySelectorAll('.color-option');
    colorOptions.forEach(option => {
        option.addEventListener('click', function() {
            // Remove selected class from all options
            colorOptions.forEach(opt => opt.classList.remove('selected'));
            
            // Add selected class to clicked option
            this.classList.add('selected');
            
            // Update ESP boxes color in the simulation if ESP is enabled
            if (document.getElementById('esp-toggle').checked) {
                const boxes = document.querySelectorAll('.esp-box');
                boxes.forEach(box => {
                    box.style.borderColor = this.style.backgroundColor;
                });
            }
        });
    });
    
    // Initialize the game simulation
    initGameSimulation();
    
    // Connect modules to the simulation
    jumpModule.init(document.getElementById('jump-toggle'), document.getElementById('jump-height-slider'));
    flyModule.init(document.getElementById('fly-toggle'), document.getElementById('fly-speed-slider'));
    aimbotModule.init(document.getElementById('aimbot-toggle'), document.getElementById('aimbot-smoothness'));
    espModule.init(document.getElementById('esp-toggle'), document.querySelector('.color-option.selected'));
    teleportModule.init(document.getElementById('teleport-toggle'), document.querySelectorAll('input[name="teleport-type"]'));
    wallhackModule.init(document.getElementById('wallhack-toggle'), document.getElementById('wall-transparency'));
    
    // Keyboard shortcuts
    document.addEventListener('keydown', function(e) {
        // 'T' key for teleport
        if (e.key === 't' || e.key === 'T') {
            const teleportToggle = document.getElementById('teleport-toggle');
            if (teleportToggle.checked) {
                teleportToTarget();
            }
        }
        
        // 'L' key for target lock/unlock
        if (e.key === 'l' || e.key === 'L') {
            const aimbotToggle = document.getElementById('aimbot-toggle');
            const lockTargetToggle = document.getElementById('aimbot-lock-target');
            if (aimbotToggle && aimbotToggle.checked && lockTargetToggle) {
                // Toggle the lock state
                lockTargetToggle.checked = !lockTargetToggle.checked;
                
                // Trigger the change event
                const event = new Event('change');
                lockTargetToggle.dispatchEvent(event);
            }
        }
        
        // 'F' key for flight toggle
        if (e.key === 'f' || e.key === 'F') {
            const flyToggle = document.getElementById('fly-toggle');
            if (flyToggle) {
                // Toggle flight
                flyToggle.checked = !flyToggle.checked;
                
                // Trigger the change event
                const event = new Event('change');
                flyToggle.dispatchEvent(event);
            }
        }
        
        // 'INSERT' key toggles menu visibility
        if (e.key === 'Insert') {
            const menu = document.getElementById('mod-menu');
            if (menu) {
                // Toggle menu visibility
                menu.style.display = menu.style.display === 'none' ? 'block' : 'none';
            }
        }
        
        // 'V' key for wallhack toggle
        if (e.key === 'v' || e.key === 'V') {
            const wallhackToggle = document.getElementById('wallhack-toggle');
            if (wallhackToggle) {
                // Toggle wallhack
                wallhackToggle.checked = !wallhackToggle.checked;
                
                // Trigger the change event
                const event = new Event('change');
                wallhackToggle.dispatchEvent(event);
            }
        }
        
        // Allow flying with arrow keys when flight is enabled
        const flyToggle = document.getElementById('fly-toggle');
        if (flyToggle && flyToggle.checked) {
            const flySpeedSlider = document.getElementById('fly-speed-slider');
            const speed = parseInt(flySpeedSlider.value);
            
            if (e.key === 'ArrowUp') {
                playerHeight = Math.min(90, playerHeight + speed);
                playerSelf.style.bottom = `${playerHeight}%`;
                updateAimbotLine();
            } else if (e.key === 'ArrowDown') {
                playerHeight = Math.max(10, playerHeight - speed);
                playerSelf.style.bottom = `${playerHeight}%`;
                updateAimbotLine();
            }
        }
    });
    
    // Teleport button setup
    const teleportBtn = document.getElementById('teleport-activate');
    if (teleportBtn) {
        teleportBtn.addEventListener('click', teleportToTarget);
    }
    
    // Target locking functionality
    const lockTargetToggle = document.getElementById('aimbot-lock-target');
    if (lockTargetToggle) {
        lockTargetToggle.addEventListener('change', function() {
            if (this.checked) {
                const targetedEnemy = findAimbotTarget();
                if (targetedEnemy) {
                    targetedEnemy.element.classList.add('locked-target');
                }
            } else {
                document.querySelectorAll('.locked-target').forEach(el => {
                    el.classList.remove('locked-target');
                });
            }
        });
    }
    
    // Function to find the current aimbot target
    function findAimbotTarget() {
        if (!window.gameSimulation || !window.gameSimulation.player) return null;
        
        const playerRect = window.gameSimulation.player.getBoundingClientRect();
        const playerCenterX = playerRect.left + playerRect.width / 2;
        const playerCenterY = playerRect.top + playerRect.height / 2;
        
        let closestEnemy = null;
        let closestDistance = Infinity;
        
        window.gameSimulation.enemies.forEach(enemy => {
            const enemyRect = enemy.getBoundingClientRect();
            const enemyCenterX = enemyRect.left + enemyRect.width / 2;
            const enemyCenterY = enemyRect.top + enemyRect.height / 2;
            
            const distance = Math.sqrt(
                Math.pow(playerCenterX - enemyCenterX, 2) + 
                Math.pow(playerCenterY - enemyCenterY, 2)
            );
            
            if (distance < closestDistance) {
                closestDistance = distance;
                closestEnemy = {
                    element: enemy,
                    centerX: enemyCenterX,
                    centerY: enemyCenterY,
                    distance: distance
                };
            }
        });
        
        return closestEnemy;
    }
    
    // Function to teleport to the current target
    function teleportToTarget() {
        const teleportToggle = document.getElementById('teleport-toggle');
        if (!teleportToggle.checked) return;
        
        // Check if we have a locked target
        let targetEnemy = null;
        const lockedTarget = document.querySelector('.locked-target');
        
        if (lockedTarget) {
            const enemyRect = lockedTarget.getBoundingClientRect();
            targetEnemy = {
                element: lockedTarget,
                centerX: enemyRect.left + enemyRect.width / 2,
                centerY: enemyRect.top + enemyRect.height / 2
            };
        } else {
            // Use aimbot target if no locked target
            targetEnemy = findAimbotTarget();
        }
        
        if (targetEnemy && window.gameSimulation && window.gameSimulation.player) {
            // Get the target position in percentage
            const gameViewRect = document.getElementById('game-view').getBoundingClientRect();
            const relativeX = (targetEnemy.centerX - gameViewRect.left) / gameViewRect.width * 100;
            const relativeBottom = 100 - ((targetEnemy.centerY - gameViewRect.top) / gameViewRect.height * 100);
            
            // Update player position
            window.gameSimulation.player.style.left = `${relativeX}%`;
            window.gameSimulation.player.style.bottom = `${relativeBottom}%`;
            
            // Flash teleport effect
            window.gameSimulation.player.classList.add('teleport-effect');
            setTimeout(() => {
                window.gameSimulation.player.classList.remove('teleport-effect');
            }, 500);
            
            // Update aimbot line
            if (window.gameSimulation.updateAimbotLine) {
                window.gameSimulation.updateAimbotLine();
            }
            
            // Simulate teleport action
            teleportModule.teleportToTarget(targetEnemy.element.id || "target");
        }
    }
});

function initGameSimulation() {
    const gameView = document.getElementById('game-view');
    const playerSelf = document.getElementById('player-self');
    const enemyCount = 5;
    const enemies = [];
    
    // Create walls for wall hack demonstration
    const wallCount = 3;
    for (let i = 0; i < wallCount; i++) {
        const wall = document.createElement('div');
        wall.className = 'wall';
        
        // Random size and position
        const width = Math.floor(Math.random() * 100) + 50; // 50-150px
        const height = Math.floor(Math.random() * 80) + 40; // 40-120px
        
        const maxX = gameView.offsetWidth - width;
        const maxY = gameView.offsetHeight - height;
        
        const left = Math.floor(Math.random() * maxX);
        const top = Math.floor(Math.random() * maxY);
        
        wall.style.width = `${width}px`;
        wall.style.height = `${height}px`;
        wall.style.left = `${left}px`;
        wall.style.top = `${top}px`;
        
        gameView.appendChild(wall);
    }
    
    // Create enemy players
    for (let i = 0; i < enemyCount; i++) {
        const enemy = document.createElement('div');
        enemy.className = 'player player-enemy';
        
        // Random position
        const left = Math.random() * 90 + 5; // 5% to 95%
        const top = Math.random() * 80 + 10; // 10% to 90%
        
        enemy.style.left = `${left}%`;
        enemy.style.top = `${top}%`;
        
        // Store original position for later use
        enemy.dataset.originalLeft = left;
        enemy.dataset.originalTop = top;
        
        // Random movement
        setInterval(() => {
            if (Math.random() > 0.7) {
                const newLeft = parseFloat(enemy.dataset.originalLeft) + (Math.random() * 10 - 5);
                const newTop = parseFloat(enemy.dataset.originalTop) + (Math.random() * 10 - 5);
                
                // Keep within bounds
                const boundedLeft = Math.max(5, Math.min(95, newLeft));
                const boundedTop = Math.max(5, Math.min(95, newTop));
                
                enemy.style.left = `${boundedLeft}%`;
                enemy.style.top = `${boundedTop}%`;
            }
        }, 2000);
        
        gameView.appendChild(enemy);
        enemies.push(enemy);
    }
    
    // Simulation controls
    const moveLeftBtn = document.getElementById('move-left');
    const moveRightBtn = document.getElementById('move-right');
    const jumpBtn = document.getElementById('jump-button');
    const flyUpBtn = document.getElementById('fly-up');
    const flyDownBtn = document.getElementById('fly-down');
    
    let playerPosition = 50; // %
    let playerHeight = 10; // % from bottom
    let isJumping = false;
    
    // Move player left
    moveLeftBtn.addEventListener('click', () => {
        playerPosition = Math.max(5, playerPosition - 5);
        playerSelf.style.left = `${playerPosition}%`;
        updateAimbotLine();
    });
    
    // Move player right
    moveRightBtn.addEventListener('click', () => {
        playerPosition = Math.min(95, playerPosition + 5);
        playerSelf.style.left = `${playerPosition}%`;
        updateAimbotLine();
    });
    
    // Jump functionality
    jumpBtn.addEventListener('click', () => {
        if (isJumping) return;
        
        isJumping = true;
        const jumpToggle = document.getElementById('jump-toggle');
        const jumpHeightSlider = document.getElementById('jump-height-slider');
        
        // Calculate jump height based on slider if enabled
        let jumpHeightMultiplier = 1;
        if (jumpToggle.checked) {
            jumpHeightMultiplier = parseInt(jumpHeightSlider.value);
        }
        
        const maxJumpHeight = 30 * jumpHeightMultiplier;
        let jumpHeight = 0;
        const jumpInterval = setInterval(() => {
            if (jumpHeight < maxJumpHeight) {
                // Going up
                jumpHeight += 2;
                playerHeight += 2;
            } else if (playerHeight > 10) {
                // Coming down
                playerHeight -= 2;
            } else {
                // Finished jump
                playerHeight = 10;
                isJumping = false;
                clearInterval(jumpInterval);
            }
            
            playerSelf.style.bottom = `${playerHeight}%`;
            updateAimbotLine();
        }, 30);
    });
    
    // Fly controls
    flyUpBtn.addEventListener('click', () => {
        const flyToggle = document.getElementById('fly-toggle');
        if (!flyToggle.checked) return;
        
        const flySpeedSlider = document.getElementById('fly-speed-slider');
        const speed = parseInt(flySpeedSlider.value);
        
        playerHeight = Math.min(90, playerHeight + speed);
        playerSelf.style.bottom = `${playerHeight}%`;
        updateAimbotLine();
    });
    
    flyDownBtn.addEventListener('click', () => {
        const flyToggle = document.getElementById('fly-toggle');
        if (!flyToggle.checked) return;
        
        const flySpeedSlider = document.getElementById('fly-speed-slider');
        const speed = parseInt(flySpeedSlider.value);
        
        playerHeight = Math.max(10, playerHeight - speed);
        playerSelf.style.bottom = `${playerHeight}%`;
        updateAimbotLine();
    });
    
    // Update aimbot line and ESP visualization
    function updateAimbotLine() {
        const aimbotToggle = document.getElementById('aimbot-toggle');
        const espToggle = document.getElementById('esp-toggle');
        
        // Handle ESP (Wall Hack)
        enemies.forEach(enemy => {
            // Remove ESP classes
            enemy.classList.remove('esp-visible');
            enemy.classList.remove('aimbot-target');
            
            // Apply ESP if enabled (wall hack)
            if (espToggle.checked) {
                enemy.classList.add('esp-visible');
                
                // Update ESP box color
                const selectedColor = document.querySelector('.color-option.selected');
                if (selectedColor) {
                    enemy.style.borderColor = selectedColor.style.backgroundColor;
                }
                
                // Also mark game container for wall hack
                gameView.classList.add('esp-active');
            } else {
                gameView.classList.remove('esp-active');
            }
        });
        
        // For walls transparency (wall hack) - Using the wallhackModule
        if (wallhackModule && typeof wallhackModule.updateWallhackStatus === 'function') {
            wallhackModule.updateWallhackStatus();
        }
        
        // Handle aimbot
        if (!aimbotToggle.checked) return;
        
        // First check for locked target
        let targetEnemy = null;
        const lockedTarget = document.querySelector('.locked-target');
        
        if (lockedTarget) {
            const enemyRect = lockedTarget.getBoundingClientRect();
            targetEnemy = {
                element: lockedTarget,
                centerX: enemyRect.left + enemyRect.width / 2,
                centerY: enemyRect.top + enemyRect.height / 2
            };
        } else {
            // Find closest enemy
            let closestEnemy = null;
            let closestDistance = Infinity;
            
            const playerRect = playerSelf.getBoundingClientRect();
            const playerCenterX = playerRect.left + playerRect.width / 2;
            const playerCenterY = playerRect.top + playerRect.height / 2;
            
            enemies.forEach(enemy => {
                const enemyRect = enemy.getBoundingClientRect();
                const enemyCenterX = enemyRect.left + enemyRect.width / 2;
                const enemyCenterY = enemyRect.top + enemyRect.height / 2;
                
                const distance = Math.sqrt(
                    Math.pow(playerCenterX - enemyCenterX, 2) + 
                    Math.pow(playerCenterY - enemyCenterY, 2)
                );
                
                if (distance < closestDistance) {
                    closestDistance = distance;
                    closestEnemy = {
                        element: enemy,
                        centerX: enemyCenterX,
                        centerY: enemyCenterY
                    };
                }
            });
            
            targetEnemy = closestEnemy;
        }
        
        // Apply aimbot visualization
        if (targetEnemy) {
            const playerRect = playerSelf.getBoundingClientRect();
            const playerCenterX = playerRect.left + playerRect.width / 2;
            const playerCenterY = playerRect.top + playerRect.height / 2;
            
            // Mark the target
            targetEnemy.element.classList.add('aimbot-target');
            
            // Draw line to target
            aimbotModule.updateTargetLine(
                playerCenterX, 
                playerCenterY, 
                targetEnemy.centerX, 
                targetEnemy.centerY
            );
            
            // Create/update aimbot line visually
            // Find or create the aimbot line
            let aimbotLine = document.querySelector('.aimbot-line');
            if (!aimbotLine) {
                aimbotLine = document.createElement('div');
                aimbotLine.className = 'aimbot-line';
                gameView.appendChild(aimbotLine);
            }
            
            // Calculate angle and length for the line
            const angle = Math.atan2(
                targetEnemy.centerY - playerCenterY,
                targetEnemy.centerX - playerCenterX
            );
            
            const length = Math.sqrt(
                Math.pow(targetEnemy.centerX - playerCenterX, 2) + 
                Math.pow(targetEnemy.centerY - playerCenterY, 2)
            );
            
            // Apply styles to the line
            aimbotLine.style.display = 'block';
            aimbotLine.style.width = `${length}px`;
            aimbotLine.style.left = `${playerCenterX}px`;
            aimbotLine.style.top = `${playerCenterY}px`;
            aimbotLine.style.transform = `rotate(${angle}rad)`;
            aimbotLine.style.transformOrigin = 'left center';
            aimbotLine.style.zIndex = '300';
        } else {
            // Hide aimbot line if no target
            const aimbotLine = document.querySelector('.aimbot-line');
            if (aimbotLine) {
                aimbotLine.style.display = 'none';
            }
        }
    }
    
    // Expose enemies to other modules
    window.gameSimulation = {
        player: playerSelf,
        enemies: enemies,
        updateAimbotLine: updateAimbotLine
    };
}
