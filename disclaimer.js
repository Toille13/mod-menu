document.addEventListener('DOMContentLoaded', function() {
    const disclaimerOverlay = document.getElementById('disclaimer-overlay');
    const acknowledgeBtn = document.getElementById('acknowledge-btn');
    
    // Check if user has already acknowledged the disclaimer
    const hasAcknowledged = localStorage.getItem('mod-menu-disclaimer-acknowledged');
    
    if (hasAcknowledged) {
        disclaimerOverlay.style.display = 'none';
    }
    
    acknowledgeBtn.addEventListener('click', function() {
        // Hide the disclaimer
        disclaimerOverlay.style.display = 'none';
        
        // Store that user has acknowledged the disclaimer
        localStorage.setItem('mod-menu-disclaimer-acknowledged', 'true');
        
        // Log the educational purpose
        console.log('This is a conceptual demonstration for educational purposes only.');
    });
    
    // Display warning in console
    console.warn(
        "%cEDUCATIONAL DEMONSTRATION ONLY\n" +
        "%cThis is a conceptual UI that does not modify any games.\n" +
        "Using actual cheats in online games violates Terms of Service and can result in bans.",
        "color: red; font-size: 24px; font-weight: bold;",
        "color: orange; font-size: 16px;"
    );
});
