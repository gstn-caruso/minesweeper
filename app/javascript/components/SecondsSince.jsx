import React, {useState, useEffect} from 'react';

function SecondsSince({dateTime}) {
  function secondsSinceGivenTime(dateTime) {
    const now = new Date();
    const givenTime = new Date(dateTime);

    return Math.floor((now - givenTime) / 1000)
  }

  const [seconds, setSeconds] = useState(secondsSinceGivenTime(dateTime))

  useEffect(() => {
    let interval;

    interval = setInterval(() => {
      setSeconds(seconds => seconds + 1)
    }, 1000)

    return () => clearInterval(interval)
  }, [seconds])

  return <p>{seconds}</p>
}

export default SecondsSince