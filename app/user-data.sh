#!/bin/bash

# AWS EC2 User Data Script for Web Server Setup
# This script runs when an EC2 instance launches

# Update system packages
yum update -y

# Install Apache web server
yum install -y httpd

# Start and enable Apache
systemctl start httpd
systemctl enable httpd

# Create the website directory
mkdir -p /var/www/html

# Create the main HTML file
cat > /var/www/html/index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AWS Load Balancer Auto Scaling Demo</title>
    <link rel="stylesheet" href="style.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
    <div class="container">
        <header>
            <h1>🚀 AWS Load Balancer Auto Scaling Demo</h1>
            <p class="subtitle">High Availability Web Application with Elastic Scaling</p>
        </header>

        <main>
            <div class="info-card">
                <h2>Server Information</h2>
                <div class="server-info">
                    <div class="info-item">
                        <span class="label">Instance ID:</span>
                        <span class="value" id="instance-id">INSTANCE_ID</span>
                    </div>
                    <div class="info-item">
                        <span class="label">Availability Zone:</span>
                        <span class="value" id="availability-zone">AVAILABILITY_ZONE</span>
                    </div>
                    <div class="info-item">
                        <span class="label">Instance Type:</span>
                        <span class="value" id="instance-type">INSTANCE_TYPE</span>
                    </div>
                    <div class="info-item">
                        <span class="label">Private IP:</span>
                        <span class="value" id="private-ip">PRIVATE_IP</span>
                    </div>
                    <div class="info-item">
                        <span class="label">Launch Time:</span>
                        <span class="value" id="launch-time">LAUNCH_TIME</span>
                    </div>
                </div>
            </div>

            <div class="architecture-card">
                <h2>Architecture Overview</h2>
                <div class="architecture-flow">
                    <div class="arch-item">
                        <div class="arch-icon">🌐</div>
                        <div class="arch-label">Internet</div>
                    </div>
                    <div class="arch-arrow">→</div>
                    <div class="arch-item">
                        <div class="arch-icon">⚖️</div>
                        <div class="arch-label">Application<br>Load Balancer</div>
                    </div>
                    <div class="arch-arrow">→</div>
                    <div class="arch-item">
                        <div class="arch-icon">📈</div>
                        <div class="arch-label">Auto Scaling<br>Group</div>
                    </div>
                    <div class="arch-arrow">→</div>
                    <div class="arch-item highlight">
                        <div class="arch-icon">🖥️</div>
                        <div class="arch-label">This EC2<br>Instance</div>
                    </div>
                </div>
            </div>

            <div class="features-grid">
                <div class="feature-card">
                    <div class="feature-icon">🔄</div>
                    <h3>Auto Scaling</h3>
                    <p>Automatically scales EC2 instances based on CPU utilization and demand patterns.</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">⚡</div>
                    <h3>High Performance</h3>
                    <p>Load balancer distributes traffic evenly across healthy instances for optimal performance.</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">🛡️</div>
                    <h3>High Availability</h3>
                    <p>Multi-AZ deployment ensures your application remains available even during failures.</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">💰</div>
                    <h3>Cost Efficient</h3>
                    <p>Pay only for the resources you use with automatic scaling up and down.</p>
                </div>
            </div>

            <div class="action-buttons">
                <button id="refresh-btn" class="btn btn-primary">
                    🔄 Refresh Page
                </button>
                <button id="cpu-test-btn" class="btn btn-secondary">
                    🔥 Simulate CPU Load
                </button>
            </div>

            <div class="status-card">
                <h2>Instance Status</h2>
                <div class="status-info">
                    <div class="status-item healthy">
                        <span class="status-dot"></span>
                        <span>Instance is healthy and serving traffic</span>
                    </div>
                    <div class="status-item">
                        <span class="status-dot"></span>
                        <span>Connected to Load Balancer</span>
                    </div>
                    <div class="status-item">
                        <span class="status-dot"></span>
                        <span>Auto Scaling Group: ${project_name}-asg</span>
                    </div>
                </div>
            </div>
        </main>

        <footer>
            <p>&copy; 2024 AWS Load Balancer Auto Scaling Demo | Instance served at LAUNCH_TIME</p>
        </footer>
    </div>

    <script>
        // Refresh button functionality
        document.getElementById('refresh-btn').addEventListener('click', function() {
            location.reload();
        });

        // CPU Test button functionality
        document.getElementById('cpu-test-btn').addEventListener('click', function() {
            this.textContent = '🔥 Running CPU Test...';
            this.disabled = true;
            
            // Simulate CPU load by running intensive calculations
            const startTime = Date.now();
            let result = 0;
            
            const intensiveTask = () => {
                for (let i = 0; i < 1000000; i++) {
                    result += Math.random() * Math.random();
                }
                
                if (Date.now() - startTime < 30000) { // Run for 30 seconds
                    setTimeout(intensiveTask, 10);
                } else {
                    this.textContent = '🔥 Simulate CPU Load';
                    this.disabled = false;
                    alert('CPU load test completed! Check CloudWatch metrics and Auto Scaling activity.');
                }
            };
            
            intensiveTask();
        });
    </script>
</body>
</html>
EOF

# Create the CSS file
cat > /var/www/html/style.css << 'EOF'
/* Reset and base styles */
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
    line-height: 1.6;
    color: #333;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    min-height: 100vh;
}

.container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 20px;
    min-height: 100vh;
    display: flex;
    flex-direction: column;
}

/* Header Styles */
header {
    text-align: center;
    margin-bottom: 40px;
    color: white;
}

header h1 {
    font-size: 3rem;
    font-weight: 700;
    margin-bottom: 10px;
    text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
}

.subtitle {
    font-size: 1.2rem;
    opacity: 0.9;
    font-weight: 300;
}

/* Main Content */
main {
    flex: 1;
    display: flex;
    flex-direction: column;
    gap: 30px;
}

/* Card Styles */
.info-card,
.architecture-card,
.status-card {
    background: white;
    padding: 30px;
    border-radius: 15px;
    box-shadow: 0 10px 30px rgba(0,0,0,0.1);
    backdrop-filter: blur(10px);
}

.info-card h2,
.architecture-card h2,
.status-card h2 {
    font-size: 1.8rem;
    margin-bottom: 20px;
    color: #2c3e50;
    font-weight: 600;
}

/* Server Info */
.server-info {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
    gap: 15px;
}

.info-item {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 15px;
    background: #f8f9fa;
    border-radius: 8px;
    border-left: 4px solid #667eea;
}

.label {
    font-weight: 600;
    color: #495057;
}

.value {
    font-weight: 500;
    color: #2c3e50;
    font-family: 'Monaco', 'Menlo', monospace;
}

/* Architecture Flow */
.architecture-flow {
    display: flex;
    align-items: center;
    justify-content: center;
    flex-wrap: wrap;
    gap: 20px;
}

.arch-item {
    text-align: center;
    padding: 20px;
    background: #f8f9fa;
    border-radius: 12px;
    min-width: 120px;
    transition: transform 0.3s ease;
}

.arch-item:hover {
    transform: translateY(-5px);
}

.arch-item.highlight {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    box-shadow: 0 10px 25px rgba(102, 126, 234, 0.3);
}

.arch-icon {
    font-size: 2.5rem;
    margin-bottom: 10px;
}

.arch-label {
    font-size: 0.9rem;
    font-weight: 600;
    color: #495057;
}

.arch-item.highlight .arch-label {
    color: white;
}

.arch-arrow {
    font-size: 2rem;
    color: #667eea;
    font-weight: bold;
}

/* Features Grid */
.features-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
    gap: 25px;
}

.feature-card {
    background: white;
    padding: 25px;
    border-radius: 12px;
    text-align: center;
    box-shadow: 0 5px 20px rgba(0,0,0,0.1);
    transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.feature-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 15px 40px rgba(0,0,0,0.15);
}

.feature-icon {
    font-size: 3rem;
    margin-bottom: 15px;
}

.feature-card h3 {
    font-size: 1.4rem;
    margin-bottom: 15px;
    color: #2c3e50;
}

.feature-card p {
    color: #6c757d;
    line-height: 1.6;
}

/* Action Buttons */
.action-buttons {
    display: flex;
    justify-content: center;
    gap: 20px;
    flex-wrap: wrap;
}

.btn {
    padding: 15px 30px;
    border: none;
    border-radius: 8px;
    font-size: 1rem;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s ease;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

.btn-primary {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
}

.btn-primary:hover {
    transform: translateY(-2px);
    box-shadow: 0 10px 25px rgba(102, 126, 234, 0.4);
}

.btn-secondary {
    background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
    color: white;
}

.btn-secondary:hover {
    transform: translateY(-2px);
    box-shadow: 0 10px 25px rgba(245, 87, 108, 0.4);
}

.btn:disabled {
    opacity: 0.6;
    cursor: not-allowed;
    transform: none;
}

/* Status Card */
.status-info {
    display: flex;
    flex-direction: column;
    gap: 15px;
}

.status-item {
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 10px;
    background: #f8f9fa;
    border-radius: 8px;
}

.status-dot {
    width: 12px;
    height: 12px;
    border-radius: 50%;
    background: #28a745;
    animation: pulse 2s infinite;
}

@keyframes pulse {
    0% { opacity: 1; }
    50% { opacity: 0.5; }
    100% { opacity: 1; }
}

/* Footer */
footer {
    text-align: center;
    padding: 30px 0;
    color: white;
    opacity: 0.8;
    font-weight: 300;
}

/* Responsive Design */
@media (max-width: 768px) {
    .container {
        padding: 15px;
    }
    
    header h1 {
        font-size: 2.2rem;
    }
    
    .subtitle {
        font-size: 1rem;
    }
    
    .info-card,
    .architecture-card,
    .status-card {
        padding: 20px;
    }
    
    .architecture-flow {
        flex-direction: column;
    }
    
    .arch-arrow {
        transform: rotate(90deg);
    }
    
    .action-buttons {
        flex-direction: column;
        align-items: center;
    }
    
    .btn {
        width: 100%;
        max-width: 300px;
    }
}
EOF

# Get instance metadata and replace placeholders
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
AVAILABILITY_ZONE=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
INSTANCE_TYPE=$(curl -s http://169.254.169.254/latest/meta-data/instance-type)
PRIVATE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
LAUNCH_TIME=$(date)

# Replace placeholders in the HTML file
sed -i "s/INSTANCE_ID/$INSTANCE_ID/g" /var/www/html/index.html
sed -i "s/AVAILABILITY_ZONE/$AVAILABILITY_ZONE/g" /var/www/html/index.html
sed -i "s/INSTANCE_TYPE/$INSTANCE_TYPE/g" /var/www/html/index.html
sed -i "s/PRIVATE_IP/$PRIVATE_IP/g" /var/www/html/index.html
sed -i "s/LAUNCH_TIME/$LAUNCH_TIME/g" /var/www/html/index.html

# Set proper permissions
chown -R apache:apache /var/www/html
chmod -R 755 /var/www/html

# Configure Apache to start on boot
systemctl enable httpd

# Install CloudWatch agent for monitoring (optional)
yum install -y amazon-cloudwatch-agent

# Create a simple health check endpoint
echo "OK" > /var/www/html/health

# Log the completion
echo "$(date): Web server setup completed successfully" >> /var/log/user-data.log

# Restart Apache to ensure everything is working
systemctl restart httpd

echo "User data script completed successfully!"