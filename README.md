# REAL-TIME SYSTEM RESOURCE TRACKER  

A lightweight Windows batch file designed to monitor and display essential system resource usage metrics in real-time. This tool focuses on:  

- **CPU Usage**  
- **Memory Consumption**  
- **Disk Activity**  

This tracker is ideal for developers, IT professionals, and system administrators who need a convenient, installation-free way to monitor system health, identify resource-intensive processes, and maintain system stability.  

## Features  

1. **Real-Time Monitoring:**  
   - Displays CPU usage percentage, memory utilization, and disk activity metrics.  

2. **CPU Usage Insights:**  
   - Indicates how much of the CPU's processing power is being used by all running applications.  
   - High CPU usage (e.g., above 80–90%) might indicate resource-intensive applications or excessive process demands.  

3. **Memory Usage Insights:**  
   - Provides details on active memory usage versus free memory.  
   - Allows freeing memory when usage is high to optimize performance.  

4. **Disk Activity Insights:**  
   - Shows either storage utilization or disk read/write activity intensity.  
   - High disk usage may point to background tasks, large file access, or intensive disk operations.  
   - Includes an option to free up disk space.  

5. **Interactive Optimization Options:**  
   - Allows users to release memory or disk space to improve performance.  

## How It Works  

The batch script leverages built-in Windows command-line utilities like `tasklist`, `wmic`, and `perfmon` to extract and display system metrics.  
- CPU usage is monitored using performance counters.  
- Memory and disk usage statistics are retrieved and displayed in real time.  
- Built-in options to optimize memory and disk space when required.  

## Usage  

### Running the Tracker  

1. Download or clone the repository.  
2. Navigate to the folder containing the batch file.  
3. Run the script by double-clicking it or executing the following command in the Command Prompt:  
   ```bash
   realtime_system_resource_tracker.bat
